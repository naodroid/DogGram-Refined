//
//  RepositoryModule.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation

protocol AppModule {
    var authRepository: AuthRepository { get }
    var imagesRepository: ImagesRepository { get }
    var usersRepository: UsersRepository { get }
}

class AppRepositoryModule {
    
}
