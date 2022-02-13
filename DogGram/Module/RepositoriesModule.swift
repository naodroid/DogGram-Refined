//
//  RepositoriesModule.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation

class RepositoriesModule {
    lazy var imagesRepository: ImagesRepository = ImagesRepositoryImpl()
    lazy var usersRepository: UsersRepository = UsersRepositoryImpl()
    lazy var authRepository: AuthRepository = AuthRepository()
    lazy var postsRepository: PostsRepository = PostsRepository()
    lazy var feedbacksRepository: FeedbackRepository = FeedbackRepositoryImpl()
    lazy var analyticsRepository: AnalyticsRepository = AnalyticsRepositoryImpl()
}

protocol RepositoryModuleUsing {
    var repositoriesModule: RepositoriesModule { get }
    var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
    var postsRepository: PostsRepository { get }
    var feedbacksRepository: FeedbackRepository { get }
    var analyticsRepository: AnalyticsRepository { get }
}
extension RepositoryModuleUsing {
    var authRepository: AuthRepository { repositoriesModule.authRepository }
    var imagesRepository: ImagesRepository { repositoriesModule.imagesRepository }
    var usersRepository: UsersRepository { repositoriesModule.usersRepository }
    var postsRepository: PostsRepository { repositoriesModule.postsRepository }
    var feedbacksRepository: FeedbackRepository { repositoriesModule.feedbacksRepository }
    var analyticsRepository: AnalyticsRepository { repositoriesModule.analyticsRepository }
}

