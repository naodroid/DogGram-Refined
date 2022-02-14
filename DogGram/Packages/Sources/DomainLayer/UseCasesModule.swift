//
//  UseCasesModule.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation
import DataLayer

public final class UseCasesModule {
    public let repositoriesModule: RepositoriesModule
    
    //user
    public lazy var ownerUseCase: OwnerUseCase = OwnerUseCaseImpl(repositoriesModule: repositoriesModule)
    public lazy var usersUseCase: UsersUseCase = UsersUseCaseImpl(repositoriesModule: repositoriesModule)
    
    //post
    public lazy var postsUseCase: PostsUseCase = PostsUseCaseImpl(repositoriesModule: repositoriesModule)
    public lazy var uploadPostUseCase: UploadPostUseCase = UploadPostUseCaseImpl(repositoriesModule: repositoriesModule)
    public lazy var likeUseCase: LikeUseCase = LikeUseCaseImpl(repositoriesModule: repositoriesModule)
    
    //Comment
    public lazy var commentsUseCase: CommentsUseCase = CommentsUseCaseImpl(repositoriesModule: repositoriesModule)
    //feedback
    public lazy var feedbackUseCase: FeedbackUseCase = FeedbackUseCaseImpl(repositoriesModule: repositoriesModule)
    //analytics
    public lazy var analyticsUseCase: AnalyticsUseCase = AnalyticsUseCaseImpl(repositoriesModule: repositoriesModule)

    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
}

/// shorthand for using usecases
public protocol UseCasesModuleUsing {
    //implement this variable as let
    var useCasesModule: UseCasesModule { get }
    
    // these properties have default implementation with protocol extension
    var ownerUseCase: OwnerUseCase { get }
    var usersUseCase: UsersUseCase { get }
    var postsUseCase: PostsUseCase { get }
    var uploadPostUseCase: UploadPostUseCase { get }
    var likeUseCase: LikeUseCase { get }
    var commentsUseCase: CommentsUseCase { get }
    var feedbackUseCase: FeedbackUseCase { get }
    var analyticsUseCase: AnalyticsUseCase { get }
}
public extension UseCasesModuleUsing {
    var ownerUseCase: OwnerUseCase { useCasesModule.ownerUseCase }
    var usersUseCase: UsersUseCase { useCasesModule.usersUseCase }
    var postsUseCase: PostsUseCase { useCasesModule.postsUseCase }
    var uploadPostUseCase: UploadPostUseCase { useCasesModule.uploadPostUseCase }
    var likeUseCase: LikeUseCase {  useCasesModule.likeUseCase }
    var commentsUseCase: CommentsUseCase { useCasesModule.commentsUseCase }
    var feedbackUseCase: FeedbackUseCase { useCasesModule.feedbackUseCase }
    var analyticsUseCase: AnalyticsUseCase { useCasesModule.analyticsUseCase }
}
