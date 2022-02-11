//
//  UseCasesModule.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation

class UseCasesModule {
    let repositoriesModule: RepositoriesModule
    
    //user
    lazy var ownerUseCase: OwnerUseCase = OwnerUseCaseImpl(repositoriesModule: repositoriesModule)
    lazy var usersUseCase: UsersUseCase = UsersUseCaseImpl(repositoriesModule: repositoriesModule)
    
    //post
    lazy var postsUseCase: PostsUseCase = PostsUseCaseImpl(repositoriesModule: repositoriesModule)
    lazy var uploadPostUseCase: UploadPostUseCase = UploadPostUseCaseImpl(repositoriesModule: repositoriesModule)

    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
}

/// shorthand for using usecases
protocol UseCasesModuleUsing {
    //implement this variable as let
    var appModule: AppModule { get }
    
    // these properties have default implementation with protocol extension
    var ownerUseCase: OwnerUseCase { get }
    var usersUseCase: UsersUseCase { get }
    var postsUseCase: PostsUseCase { get }
    var uploadPostUseCase: UploadPostUseCase { get }
}
extension UseCasesModuleUsing {
    var ownerUseCase: OwnerUseCase { appModule.useCaseModule.ownerUseCase }
    var usersUseCase: UsersUseCase { appModule.useCaseModule.usersUseCase }
    var postsUseCase: PostsUseCase { appModule.useCaseModule.postsUseCase }
    var uploadPostUseCase: UploadPostUseCase { appModule.useCaseModule.uploadPostUseCase }
}
