//
//  RepositoryModule.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation
import SwiftUI

class AppModule {
    lazy var authRepository: AuthRepository = AuthRepository()
    lazy var imagesRepository: ImagesRepository = ImagesRepository()
    lazy var usersRepository: UsersRepository = UsersRepository(imageRepository: imagesRepository)
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

