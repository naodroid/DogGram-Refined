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


/// Repository for users
actor PostsRepository {
    private static let firestore = Firestore.firestore()
    private let postsRef = PostsRepository.firestore.collection("posts")
    
    private let authRepository: AuthRepository
    private let usersRepository: UsersRepository
    private let imagesRepository: ImagesRepository

    
    private var cache: [String: Post] = [:]
    
    
    nonisolated init(authRepository: AuthRepository,
                     usersRepository: UsersRepository,
                     imagesRepository: ImagesRepository) {
        self.authRepository = authRepository
        self.usersRepository = usersRepository
        self.imagesRepository = imagesRepository
    }
    
    
    // MARK: GET posts
    // To keep the post latest-info, listen Event.onPostsUpdated
    /// get owner's posts
    func getMyPostIDs() async throws -> [Post] {
        guard let currentUserID = await authRepository.currentUserID else {
            return []
        }
        return try await getPostForUser(currentUserID)
    }
    /// get posts that has been posted by the user
    func getPostForUser(_ userID: String) async throws -> [Post] {
        let query = self.postsRef.whereField(
                Post.Keys.userID.rawValue,
                isEqualTo: userID
            )
        return try await getPosts(with: query)
    }
    /// get posts for feed
    func getPostsForFeed() async throws -> [Post] {
        let query = postsRef.order(
            by: Post.Keys.dateCreated.rawValue,
            descending: true
        ).limit(to: 50)
        return try await getPosts(with: query)
    }
    func getPostsForBrowse() async throws -> [Post] {
        let posts = try await getPostsForFeed()
        return posts.shuffled()
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
    func getPosts(forPostIDs ids: [String]) -> [Post] {
        return ids.compactMap { cache[$0] }
    }
    
    // MARK: Upload Post
    @discardableResult
    func uploadPost(image: UIImage,
                    caption: String?,
                    displayName: String,
                    userID: String) async throws -> Post {
        // Create new post document
        let document = postsRef.document()
        let documentID = document.documentID
        
        // Upload image to storage
        try await imagesRepository.uploadPostImage(postID: documentID, image: image)
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

    
    
    //--------------------------------------------
    // MARK: Like/Unlike
    
    func like(post: Post) async throws {
        guard let currentUserID = await authRepository.currentUserID else {
            return
        }

        let data: [String: Any] = [
            Post.Keys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.Keys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        return try await withCheckedThrowingContinuation({ continuation in
            guard let postID = post.id else {
                continuation.resume(throwing: NSError())
                return
            }
            postsRef.document(postID).updateData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
                
                var p = post
                p.likedBy.append(currentUserID)
                p.likeCount += 1
                self.updateLocalCache(posts: [p])
            }
        })
    }
    func unlike(post: Post) async throws {
        guard
            let currentUserID = await authRepository.currentUserID,
            let postID = post.id
        else {
            return
        }

        let data: [String: Any] = [
            Post.Keys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.Keys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        return try await withCheckedThrowingContinuation({ continuation in
            postsRef.document(postID).updateData(data) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
                
                var p = post
                p.likedBy = p.likedBy.filter {$0 != currentUserID}
                p.likeCount = max(0, post.likeCount - 1)
                self.updateLocalCache(posts: [p])
            }
        })
    }
    
    
    
}
