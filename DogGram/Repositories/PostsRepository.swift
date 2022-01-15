//
//  PostsRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Repository for users
actor PostsRepository {
    private static let firestore = Firestore.firestore()
    private let postsRef = PostsRepository.firestore.collection("posts")
    
    private let authRepository: AuthRepository
    private let usersRepository: UsersRepository
    
    
    private var cache: [String: Post] = [:]
    
    
    nonisolated init(authRepository: AuthRepository,
                     usersRepository: UsersRepository) {
        self.authRepository = authRepository
        self.usersRepository = usersRepository
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
                Post.CodingKeys.userID.rawValue,
                isEqualTo: userID
            )
        return try await getPosts(with: query)
    }
    /// get posts for feed
    func getPostsForFeed() async throws -> [Post] {
        let query = postsRef.order(
            by: DatabasePostField.dateCreated,
            descending: true
        ).limit(to: 50)
        return try await getPosts(with: query)
    }
    private func getPosts(with query: Query) async throws  -> [Post] {
        return try await withCheckedThrowingContinuation { continuation in
            return query.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let posts = Post.decode(snapshot: snapshot)
                continuation.resume(returning: posts)
                self.updateLocalCache(posts: posts)
            }
        }
    }
    private func updateLocalCache(posts: [Post]) {
        posts.forEach { p in
            cache[p.postID] = p
        }
        Event.onPostsUpdated(posts: posts).post()
    }
    /// return all posts related to ids.
    func getPosts(forPostIDs ids: [String]) -> [Post] {
        return ids.compactMap { cache[$0] }
    }
    
    //--------------------------------------------
    // MARK: Like/Unlike
    
    func like(post: Post) async throws {
        guard let currentUserID = await authRepository.currentUserID else {
            return
        }

        let data: [String: Any] = [
            Post.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.CodingKeys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        return try await withCheckedThrowingContinuation({ continuation in
            postsRef.document(post.postID).updateData(data) { error in
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
        guard let currentUserID = await authRepository.currentUserID else {
            return
        }

        let data: [String: Any] = [
            Post.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1)),
            Post.CodingKeys.likedBy.rawValue: FieldValue.arrayUnion([currentUserID])
        ]
        return try await withCheckedThrowingContinuation({ continuation in
            postsRef.document(post.postID).updateData(data) { error in
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
