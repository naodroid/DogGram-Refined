//
//  FeedbackUseCase.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import DataLayer

/// Usecase related to posting feedback
public protocol FeedbackUseCase {
    func postFeedback(email: String?, message: String) async throws
}

/// Implementation
public class FeedbackUseCaseImpl: FeedbackUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    public func postFeedback(email: String?, message: String) async throws {
        try await feedbacksRepository.postFeedback(email: email, message: message)
    }
}
