//
//  RepositoriesModule.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation

class RepositoriesModule {
    lazy var imagesRepository: ImagesRepository = ImagesRepository()
    lazy var usersRepository: UsersRepository = UsersRepository(
        imageRepository: imagesRepository
    )
    lazy var authRepository: AuthRepository = AuthRepository()
    lazy var postsRepository: PostsRepository = PostsRepository(
        authRepository: authRepository,
        usersRepository: usersRepository,
        imagesRepository: imagesRepository
    )
}

protocol RepositoryModuleUsing {
    var repositoriesModule: RepositoriesModule { get }
    var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
    var postsRepository: PostsRepository { get }
}
extension RepositoryModuleUsing {
    var authRepository: AuthRepository { repositoriesModule.authRepository }
    var imagesRepository: ImagesRepository { repositoriesModule.imagesRepository }
    var usersRepository: UsersRepository { repositoriesModule.usersRepository }
    var postsRepository: PostsRepository {repositoriesModule.postsRepository }
}

