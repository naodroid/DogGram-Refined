//
//  PostUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/10.
//

import Foundation

/// usecase related to post-list
protocol PostsUseCase {
    func getMyPosts() async throws -> [Post]
    func getPostsForUser(_ userID: String) async throws -> [Post]
    func getPostsForFeed() async throws -> [Post]
    func getPostsForBrowse() async throws -> [Post]
}

class PostsUseCaseImpl: PostsUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    //
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    
    ///
    func getMyPosts() async throws -> [Post] {
        guard let userID = await authRepository.currentUserID else {
            return []
        }
        return try await postsRepository.getPostsForUser(userID)
    }
    /// get posts that has been posted by the user
    func getPostsForUser(_ userID: String) async throws -> [Post] {
        return try await postsRepository.getPostsForUser(userID)
    }
    /// get posts for feed
    func getPostsForFeed() async throws -> [Post] {
        return try await postsRepository.getPostsForFeed()
    }
    func getPostsForBrowse() async throws -> [Post] {
        return try await postsRepository.getPostsForBrowse()
    }
}


