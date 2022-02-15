//
//  RepositoriesModule.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation

public class RepositoriesModule {
    public lazy var imagesRepository: ImagesRepository = ImagesRepositoryImpl()
    public lazy var usersRepository: UsersRepository = UsersRepositoryImpl()
    public lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    public lazy var postsRepository: PostsRepository = PostsRepositoryImpl()
    public lazy var feedbacksRepository: FeedbackRepository = FeedbackRepositoryImpl()
    public lazy var analyticsRepository: AnalyticsRepository = AnalyticsRepositoryImpl()
    
    public init() {
    }
}

public protocol RepositoryModuleUsing {
    var repositoriesModule: RepositoriesModule { get }
    var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
    var postsRepository: PostsRepository { get }
    var feedbacksRepository: FeedbackRepository { get }
    var analyticsRepository: AnalyticsRepository { get }
}
public extension RepositoryModuleUsing {
    var authRepository: AuthRepository { repositoriesModule.authRepository }
    var imagesRepository: ImagesRepository { repositoriesModule.imagesRepository }
    var usersRepository: UsersRepository { repositoriesModule.usersRepository }
    var postsRepository: PostsRepository { repositoriesModule.postsRepository }
    var feedbacksRepository: FeedbackRepository { repositoriesModule.feedbacksRepository }
    var analyticsRepository: AnalyticsRepository { repositoriesModule.analyticsRepository }
}

