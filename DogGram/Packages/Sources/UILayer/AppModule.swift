//
//  RepositoryModule.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI
import DataLayer
import DomainLayer

public class AppModule {
    public lazy var repositoriesModule = RepositoriesModule()
    public lazy var useCaseModule = UseCasesModule(repositoriesModule: self.repositoriesModule)
    
    public init() {
    }
}

// 追加したいKeyをまず定義する
public struct AppModuleKey: EnvironmentKey {
    public static let defaultValue: AppModule = AppModule()
}

public extension EnvironmentValues {
    var appModule: AppModule {
        get { self[AppModuleKey.self] }
        set { self[AppModuleKey.self] = newValue }
    }
}

public protocol AppModuleUsing: UseCasesModuleUsing {
    var appModule: AppModule { get }
}
public extension AppModuleUsing {
    var useCasesModule: UseCasesModule { appModule.useCaseModule }
}
