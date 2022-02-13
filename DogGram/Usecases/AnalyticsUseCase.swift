//
//  AnalyticsUseCase.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation

/// Usecase related to sending log
protocol AnalyticsUseCase {
    func likePostDoubleTap() async
    func likePostHeartPressed() async
}

/// Implementation
class AnalyticsUseCaseImpl: AnalyticsUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    func likePostDoubleTap() async {
        await analyticsRepository.likePostDoubleTap()
    }
    func likePostHeartPressed() async {
        await analyticsRepository.likePostHeartPressed()
    }
}
