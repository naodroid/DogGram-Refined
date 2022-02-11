//
//  UserUsecase.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation
import UIKit



/// Usecase related to other users
protocol UsersUseCase {
    func getMyProfile() async throws -> User?
    func getProfile(for userID: String) async throws -> User?
    
    func getProfileImage(for userID: String) async throws -> UIImage
}

/// Implementation
class UsersUseCaseImpl: UsersUseCase, RepositoryModuleUsing {
    let repositoriesModule: RepositoriesModule
    
    init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    
    func getMyProfile() async throws -> User? {
        guard let id = await authRepository.currentUserID else {
            return nil
        }
        return try await getProfile(for: id)
    }
    func getProfile(for userID: String) async throws -> User? {
        return try await usersRepository.getProfile(for: userID)
    }
    
    
    func getProfileImage(for userID: String) async throws -> UIImage {
        return try await imagesRepository.downloadProfileImage(userID: userID)
    }
}

