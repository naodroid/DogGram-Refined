//
//  RepositoryModule.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI

class AppModule {
    lazy var imagesRepository: ImagesRepository = ImagesRepository()
    lazy var usersRepository: UsersRepository = UsersRepository(
        imageRepository: imagesRepository
    )
    lazy var authRepository: AuthRepository = AuthRepository(
        usersRepository: usersRepository,
        imagesRepository: imagesRepository
    )
    lazy var postsRepository: PostsRepository = PostsRepository(
        authRepository: authRepository,
        usersRepository: usersRepository,
        imagesRepository: imagesRepository
    )
}


// 追加したいKeyをまず定義する
struct AppModuleKey: EnvironmentKey {
    static let defaultValue: AppModule = AppModule()
}

extension EnvironmentValues {
    var appModule: AppModule {
        get { self[AppModuleKey.self] }
        set { self[AppModuleKey.self] = newValue }
    }
}



protocol AppModuleUsing {
    var appModule: AppModule { get }
    var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
    var postsRepository: PostsRepository { get }
}
extension AppModuleUsing {
    var authRepository: AuthRepository { appModule.authRepository }
    var imagesRepository: ImagesRepository { appModule.imagesRepository }
    var usersRepository: UsersRepository { appModule.usersRepository }
    var postsRepository: PostsRepository {appModule.postsRepository }
}
