//
//  UserUsecase.swift
//  DogGram
//
//  Created by nao on 2022/02/05.
//

import Foundation
import UIKit
import DataLayer


/// Usecase related to other users
public protocol UsersUseCase {
    func getMyProfile() async throws -> User?
    func getProfile(for userID: String) async throws -> User?
    
    func getProfileImage(for userID: String) async throws -> UIImage
}

/// Implementation
public final class UsersUseCaseImpl: UsersUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    
    public func getMyProfile() async throws -> User? {
        guard let id = await authRepository.currentUserID else {
            return nil
        }
        return try await getProfile(for: id)
    }
    public func getProfile(for userID: String) async throws -> User? {
        return try await usersRepository.getProfile(for: userID)
    }
    
    
    public func getProfileImage(for userID: String) async throws -> UIImage {
        return try await imagesRepository.downloadProfileImage(userID: userID)
    }
}

