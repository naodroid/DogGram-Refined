//
//  PostUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/10.
//

import Foundation
import UIKit
import DataLayer

/// usecase related to post-list
public protocol PostsUseCase {
    func getMyPosts() async throws -> [Post]
    func getPostsForUser(_ userID: String) async throws -> [Post]
    func getPostsForFeed() async throws -> [Post]
    func getPostsForBrowse() async throws -> [Post]
    
    func getImage(for post: Post) async throws -> UIImage
}

public class PostsUseCaseImpl: PostsUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    //
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    
    ///
    public func getMyPosts() async throws -> [Post] {
        guard let userID = await authRepository.currentUserID else {
            return []
        }
        return try await postsRepository.getPostsForUser(userID)
    }
    /// get posts that has been posted by the user
    public func getPostsForUser(_ userID: String) async throws -> [Post] {
        return try await postsRepository.getPostsForUser(userID)
    }
    /// get posts for feed
    public func getPostsForFeed() async throws -> [Post] {
        return try await postsRepository.getPostsForFeed()
    }
    public func getPostsForBrowse() async throws -> [Post] {
        return try await postsRepository.getPostsForBrowse()
    }
    
    public func getImage(for post: Post) async throws -> UIImage {
        guard let postID = post.id else {
            throw NSError()
        }
        return try await imagesRepository.downloadPostImage(postID: postID)
    }
}



