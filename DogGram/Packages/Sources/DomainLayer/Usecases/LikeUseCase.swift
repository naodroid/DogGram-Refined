//
//  LikeUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation
import DataLayer

/// Usecase related to like/unilke post
public protocol LikeUseCase {
    func like(post: Post) async throws
    func unlike(post: Post) async throws
}

/// Implementation
public class LikeUseCaseImpl: LikeUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    public func like(post: Post) async throws {
        guard
            let currentUserID = await authRepository.currentUserID
        else {
            throw NSError()
        }
        try await postsRepository.like(currentUserID: currentUserID,
                                       post: post)
    }
    public func unlike(post: Post) async throws {
        guard
            let currentUserID = await authRepository.currentUserID
        else {
            throw NSError()
        }
        try await postsRepository.unlike(currentUserID: currentUserID,
                                       post: post)
    }
}
