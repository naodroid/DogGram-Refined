//
//  PostsRepository.swift
//  DogGram
//
//  Created by naodroid on 2022/01/15.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol PostsRepository {
    // MARK: Get
    public func getPostsForUser(_ userID: String) async throws -> [Post]
    public func getPostsForFeed() async throws -> [Post]
    public func getPostsForBrowse() async throws -> [Post]
    public func getPostsForUser(userID: String) async throws -> [Post]
    public func delete(posts: [Post]) async throws -> [String]
    /// return all posts related to ids.
    public func getPosts(forPostIDs ids: [String]) -> [Post]
    
    // MARK: Create/Delete
    @discardableResult
    public func createPost(caption: String?,
                           displayName: String,
                           userID: String) async throws -> Post
    
    public func deletePost(id: String) async throws
    
    
    // MARK: Like/Unlike
    public func like(currentUserID: String, post: Post) async throws
    public func unlike(currentUserID: String, post: Post) async throws
    
    // MARK: Comments
    public func getComments(postID: String) async throws -> [Comment]
    public func postComment(postID: String,
                            content: String,
                            displayName: String,
                            userID: String) async throws -> Comment
    public func delete(comment: Comment,
                       in post: Post) async throws
    
    //MARK: Like comment
    public func like(comment: Comment,
                     in post: Post,
                     userID: String) async throws
    public func unlike(comment: Comment,
                       in post: Post,
                       userID: String) async throws
}

/// Repository for users
public actor PostsRepositoryImpl: PostsRepository {
    private static let firestore = Firestore.firestore()
    private let postsRef = PostsRepository.firestore.collection("posts")
    private var cache: [String: Post] = [:]
    
    public nonisolated init() {
    }
    
    // MARK: GET posts
    /// get posts that has been posted by the user
    public func getPostsForUser(_ userID: String) async throws -> [Post] {
        let query = self.postsRef.whereField(
            Post.CodingKeys.userID.rawValue,
            isEqualTo: userID
        )
        return try await getPosts(with: query)
    }
    /// get posts for feed
    public func getPostsForFeed() async throws -> [Post] {
        let query = postsRef.order(
            by: Post.CodingKeys.dateCreated.rawValue,
            descending: true
        ).limit(to: 50)
        return try await getPosts(with: query)
    }
    public func getPostsForBrowse() async throws -> [Post] {
        let posts = try await getPostsForFeed()
        return posts.shuffled()
    }
    public func getPostsForUser(userID: String) async throws -> [Post] {
        let query = postsRef
            .whereField(
                Post.CodingKeys.userID.rawValue,
                isEqualTo: userID
            )
        let posts = try await getPosts(with: query)
        return posts
    }
    ///delete posts, return deleted post ids
    public func delete(posts: [Post]) async throws -> [String] {
        return try await withThrowingTaskGroup(of: String.self) { group in
            for p in posts {
                guard let id = p.id else {
                    continue
                }
                group.addTask {
                    try await self.postsRef.document(id).delete()
                    return id
                }
            }
            var result: [String] = []
            for try await p in group {
                result.append(p)
            }
            return result
        }
    }
    
    private func getPosts(with query: Query) async throws  -> [Post] {
        let snapshot = try await query.getDocuments()
        let posts = Post.decodeArray(from: snapshot)
        self.updateLocalCache(posts: posts)
        return posts
    }
    private func updateLocalCache(posts: [Post]) {
        posts.forEach { p in
            if let id = p.id {
                cache[id] = p
            }
        }
        Event.onPostsUpdated(posts: posts).post()
    }
    /// return all posts related to ids.
    public func getPosts(forPostIDs ids: [String]) -> [Post] {
        return ids.compactMap { cache[$0] }
    }
    
    
    
    // MARK: Upload Post
    @discardableResult
    public func createPost(caption: String?,
                    displayName: String,
                    userID: String) async throws -> Post {
        // Create new post document
        let document = postsRef.document()
        let documentID = document.documentID
        
        let post = Post(id: documentID,
                        userID: userID,
                        displayName: displayName,
                        caption: caption,
                        likeCount: 0,
                        likedBy: [],
                        comments: [])
        try await document.setDataAsync(from: post)
        updateLocalCache(posts: [post])
        return post
    }
    public func deletePost(id: String) async throws {
        try await postsRef.document(id).delete()
    }
    
    
    
    //--------------------------------------------
    // MARK: Like/Unlike
    
    public func like(currentUserID: String, post: Post) async throws {
        guard let postID = post.id else {
            //TODO: Create custom error
            throw NSError()
        }
        
        let data: [String: Any] = [
            Post.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.CodingKeys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        try await postsRef.document(postID).updateData(data)
        //update local cache
        var p = post
        p.likedBy.append(currentUserID)
        p.likeCount += 1
        self.updateLocalCache(posts: [p])
    }
    public func unlike(currentUserID: String, post: Post) async throws {
        guard let postID = post.id else {
            //TODO: Create custom error
            throw NSError()
        }
        
        let data: [String: Any] = [
            Post.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.CodingKeys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        try await postsRef.document(postID).updateData(data)
        //update local cache
        var p = post
        p.likedBy = p.likedBy.filter {$0 != currentUserID}
        p.likeCount = max(0, post.likeCount - 1)
        self.updateLocalCache(posts: [p])
    }
    
    
    // MARK: Comments
    public func getComments(postID: String) async throws -> [Comment] {
        let docs = try await postsRef.document(postID)
            .collection(Post.CodingKeys.comments.rawValue)
            .order(by: Comment.CodingKeys.dateCreated.rawValue, descending: true)
            .getDocuments()
        //TODO: merge comments to cached-posts
        return Comment.decodeArray(from: docs)
    }
    public func postComment(postID: String,
                     content: String,
                     displayName: String,
                     userID: String) async throws -> Comment {
        let document = postsRef.document(postID)
            .collection(Post.CodingKeys.comments.rawValue)
            .document()
        
        let comment = Comment(id: document.documentID,
                              userID: userID,
                              displayName: displayName,
                              content: content,
                              dateCreated: nil,
                              likeCount: 0,
                              likedBy: [])
        try await document.setDataAsync(from: comment)
        //TODO: updateLocalCache(posts: [post])
        return comment
    }
    public func delete(comment: Comment,
                in post: Post) async throws {
        guard
            let commentID = comment.id,
            let postID = post.id
        else {
            throw NSError()
        }
        try await postsRef.document(postID)
            .collection(Post.CodingKeys.comments.rawValue)
            .document()
            .delete()
    }
    
    //MARK: Like comment
    public func like(comment: Comment,
              in post: Post,
              userID: String) async throws {
        guard
            let commentID = comment.id,
            let postID = post.id
        else {
            throw NSError()
        }
        let data: [String: Any] = [
            Comment.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Comment.CodingKeys.likedBy.rawValue: FieldValue.arrayUnion([userID])
        ]
        let comment = postsRef.document(postID)
            .collection(Post.CodingKeys.comments.rawValue)
            .document(commentID)
        try await comment.updateData(data)
    }
    public func unlike(comment: Comment,
                in post: Post,
                userID: String) async throws {
        guard
            let commentID = comment.id,
            let postID = post.id
        else {
            throw NSError()
        }
        let data: [String: Any] = [
            Comment.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(-1)),
            Comment.CodingKeys.likedBy.rawValue: FieldValue.arrayRemove([userID])
        ]
        let comment = postsRef.document(postID)
            .collection(Post.CodingKeys.comments.rawValue)
            .document(commentID)
        try await comment.updateData(data)
    }
}
