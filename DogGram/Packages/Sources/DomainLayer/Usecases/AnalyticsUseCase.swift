//
//  AnalyticsUseCase.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import DataLayer

/// Usecase related to sending log
public protocol AnalyticsUseCase {
    func likePostDoubleTap() async
    func likePostHeartPressed() async
}

/// Implementation
public class AnalyticsUseCaseImpl: AnalyticsUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    public func likePostDoubleTap() async {
        await analyticsRepository.likePostDoubleTap()
    }
    public func likePostHeartPressed() async {
        await analyticsRepository.likePostHeartPressed()
    }
}
