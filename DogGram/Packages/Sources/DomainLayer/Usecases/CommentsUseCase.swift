//
//  CommentsUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation
import DataLayer

/// Usecase related to like/unlike post
public protocol CommentsUseCase {
    func getComments(for post: Post) async throws -> [Comment]
    func post(content: String, to post: Post) async throws -> Comment
    func delete(comment: Comment, in post: Post) async throws

    //
    func like(comment: Comment, in post: Post) async throws
    func unlike(comment: Comment, in post: Post) async throws
}

/// Implementation
public final class CommentsUseCaseImpl: CommentsUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    public func getComments(for post: Post) async throws -> [Comment] {
        guard let postID = post.id else {
            throw NSError()
        }
        return try await postsRepository.getComments(postID: postID)
    }
    public func post(content: String, to post: Post) async throws -> Comment {
        guard
            let postID = post.id,
            let user = await authRepository.currentUser,
            let userID = user.id
        else {
            throw NSError()
        }
        return try await postsRepository.postComment(postID: postID,
                                              content: content,
                                              displayName: user.displayName,
                                              userID: userID)
    }
    public func delete(comment: Comment, in post: Post) async throws {
        guard
            let user = await authRepository.currentUser,
            let userID = user.id,
            userID == comment.userID
        else {
            throw NSError()
        }

        try await postsRepository.delete(comment: comment, in: post)
    }
    //
    public func like(comment: Comment, in post: Post) async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        return try await postsRepository.like(comment: comment,
                                              in: post,
                                              userID: userID)
    }
    public func unlike(comment: Comment, in post: Post) async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        return try await postsRepository.unlike(comment: comment,
                                                in: post,
                                                userID: userID)
        
    }
}
