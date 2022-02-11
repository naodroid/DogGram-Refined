//
//  RepositoryModule.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI

class AppModule {
    lazy var repositoriesModule = RepositoriesModule()
    lazy var useCaseModule = UseCasesModule(repositoriesModule: self.repositoriesModule)
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
    //var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
    var postsRepository: PostsRepository { get }
}
extension AppModuleUsing {
    //var authRepository: AuthRepository { appModule.repositoriesModule.authRepository }
    var imagesRepository: ImagesRepository { appModule.repositoriesModule.imagesRepository }
    var usersRepository: UsersRepository { appModule.repositoriesModule.usersRepository }
    var postsRepository: PostsRepository {appModule.repositoriesModule.postsRepository }
}
