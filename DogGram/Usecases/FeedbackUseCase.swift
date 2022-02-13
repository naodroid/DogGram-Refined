//
//  FeedbackUseCase.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation

/// Usecase related to posting feedback
protocol FeedbackUseCase {
    func postFeedback(email: String?, message: String) async throws
}

/// Implementation
class FeedbackUseCaseImpl: FeedbackUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    func postFeedback(email: String?, message: String) async throws {
        try await feedbacksRepository.postFeedback(email: email, message: message)
    }
}
