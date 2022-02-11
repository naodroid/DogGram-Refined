//
//  LikeUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation

/// Usecase related to like/unilke post
protocol LikeUseCase {
    func like(post: Post) async throws
    func unlike(post: Post) async throws
}

/// Implementation
class LikeUseCaseImpl: LikeUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    func like(post: Post) async throws {
        guard
            let currentUserID = await authRepository.currentUserID
        else {
            throw NSError()
        }
        try await postsRepository.like(currentUserID: currentUserID,
                                       post: post)
    }
    func unlike(post: Post) async throws {
        guard
            let currentUserID = await authRepository.currentUserID
        else {
            throw NSError()
        }
        try await postsRepository.unlike(currentUserID: currentUserID,
                                       post: post)
    }
}
