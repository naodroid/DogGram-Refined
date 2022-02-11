//
//  CommentsUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation

/// Usecase related to like/unlike post
protocol CommentsUseCase {
    func getComments(for post: Post) async throws -> [Comment]
    func post(content: String, to post: Post) async throws -> Comment
    func delete(comment: Comment, in post: Post) async throws

    //
    func like(comment: Comment, in post: Post) async throws
    func unlike(comment: Comment, in post: Post) async throws
}

/// Implementation
class CommentsUseCaseImpl: CommentsUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    func getComments(for post: Post) async throws -> [Comment] {
        guard let postID = post.id else {
            throw NSError()
        }
        return try await postsRepository.getComments(postID: postID)
    }
    func post(content: String, to post: Post) async throws -> Comment {
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
    func delete(comment: Comment, in post: Post) async throws {
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
    func like(comment: Comment, in post: Post) async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        return try await postsRepository.like(comment: comment,
                                              in: post,
                                              userID: userID)
    }
    func unlike(comment: Comment, in post: Post) async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        return try await postsRepository.unlike(comment: comment,
                                                in: post,
                                                userID: userID)
        
    }

}
