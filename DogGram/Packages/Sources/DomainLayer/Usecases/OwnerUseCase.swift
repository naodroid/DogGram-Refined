//
//  OwnerUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/10.
//

import Foundation
import UIKit
import DataLayer


/// Usecase related to app-using users
public protocol OwnerUseCase {
    /// signed in owner info
    /// if not sign-in, return nil
    var currentUser: User? { get async }
    var currentUserID: String? { get async }

    /// MARK: Signin/Up
    /// start sign in with apple
    func signInWithApple() async throws -> LoginResult
    /// start sign in with google
    func signInWithGoogle() async throws -> LoginResult
    /// start anonymous sign in
    func signUpAsAnonymous() async throws -> String
    
    // MARK: Profile
    /// create user with profile
    func createNewUser(
        userID: String,
        name: String,
        email: String,
        provider: String,
        profileImage: UIImage
    ) async throws -> User
    
    /// Update owner profile
    func update(displayName: String?, bio: String?) async throws -> User?
    func updateProfileImage(_ image: UIImage) async throws

    /// logout
    func signOut() async throws
    func deleteAccount() async throws
}

// Usecase related to using user
public final class OwnerUseCaseImpl: OwnerUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    public var currentUser: User? {
        get async {
            return await authRepository.currentUser
        }
    }
    public var currentUserID: String? {
        get async {
            return await self.currentUser?.id
        }
    }
    
    
    
    /// initializer
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    
    
    
    
    // MARK: Signin
    public func signInWithApple() async throws -> LoginResult {
        let result = try await authRepository.startSignInWithApple()
        return try await commonSignIn(result: result)
    }
    public func signInWithGoogle() async throws -> LoginResult {
        let result = try await authRepository.startSignInWithGoogle()
        return try await commonSignIn(result: result)
    }
    private func commonSignIn(result: SignInResult) async throws -> LoginResult {
        let userID = try await authRepository.getFirebaseUserUID(result: result)
        let user = try await usersRepository
            .checkIfUserExists(fromUserID: userID)
        if let user = user {
            //existing user
            await authRepository.setCurrentUser(user)
            return LoginResult.existsUser(user: user)
        } else {
            //new user
            return LoginResult.newUser(userID: userID, result: result)
        }
    }

    public func signUpAsAnonymous() async throws -> String {
        return try await authRepository.signUpAsAnonymous()
    }
    
    // MARK: Profile
    public func createNewUser(
        userID: String,
        name: String,
        email: String,
        provider: String,
        profileImage: UIImage
    ) async throws -> User {
        try await imagesRepository.uploadProfileImage(userID: userID, image: profileImage)
        let user = try await usersRepository.createNewUser(
            userID: userID,
            name: name,
            email: email,
            provider: provider
        )
        await authRepository.setCurrentUser(user)
        return user
    }
    
    public func update(displayName: String? = nil,
                bio: String? = nil) async throws -> User? {
        guard var user = await currentUser else {
            return nil
        }
        if user.id == nil {
            return user
        }
        
        if let name = displayName {
            user.displayName = name
        }
        if let bio = bio {
            user.bio = bio
        }
        try await usersRepository.updateProfile(for: user)
        await authRepository.setCurrentUser(user)
        return user
    }
    public func updateProfileImage(_ image: UIImage) async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        try await imagesRepository.uploadProfileImage(userID: userID, image: image)
    }
    
    public func signOut() async throws {
        try await authRepository.signOut()
        await authRepository.setCurrentUser(nil)
    }
    public func deleteAccount() async throws {
        guard let userID = await authRepository.currentUserID else {
            throw NSError()
        }
        try await authRepository.signOut()
        await authRepository.setCurrentUser(nil)
        //delete profile
        try? await usersRepository.deleteUser(userID: userID)
        try? await imagesRepository.deleteProfileImage(userID: userID)
        //delete posts
        let posts = try await postsRepository.getPostsForUser(userID)
        let ids = posts.compactMap(\.id)
        for id in ids {
            try await imagesRepository.deletePostImage(postID: id)
        }
    }
}
