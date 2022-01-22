//
//  UsersRepository.swift
//  DogGram
//
//  Created by naodroid on 2022/01/09.
//

import Foundation
import class UIKit.UIImage
import Combine
import FirebaseAuth
import FirebaseFirestore

enum LoginResult {
    case existsUser(user: User)
    case newUser(providerID: String, result: SignInResult)
}


/// Manage user info related to owner
actor AuthRepository {
    
    private(set) var currentUser: User?
    var currentUserID: String? {
        currentUser?.documentID
    }
    
    private let signInWithApple = SignInWithApple()
    private let signInWithGoole = SignInWithGoogle()

    private let usersRepository: UsersRepository
    private let imagesRepository: ImagesRepository

    
    private var cache: [String: Post] = [:]
    
    nonisolated init(usersRepository: UsersRepository,
                     imagesRepository: ImagesRepository) {
        self.usersRepository = usersRepository
        self.imagesRepository = imagesRepository
        self.currentUser = DogGramStorage.currentUser
        
        if let user = Auth.auth().currentUser,
           self.currentUser?.documentID != user.uid {
            //TODO: Check UserID is valid or not
        }
    }
    
    private func setCurrentUser(_ user: User?) {
        self.currentUser = user
        DogGramStorage.currentUser = user
        Event.onUserChanged(userID: user?.documentID).post()
    }
    
    // MARK: Sign in with providers
    /// Start signin with apple
    /// After succeeded, call `createProfile` to create user account.
    func startSignInWithApple() async throws -> LoginResult {
        let result = try await signInWithApple.start()
        return try await commonSignIn(result: result)
    }
    /// Start signin with google
    /// After succeeded, call `createProfile` to create user account.
    func startSignINWithGoogle() async throws -> LoginResult {
        let result = try await signInWithGoole.start()
        return try await commonSignIn(result: result)
    }
    private func commonSignIn(result: SignInResult) async throws -> LoginResult {
        let ret = try await Auth.auth().signIn(with: result.credential)
        let providerID = ret.user.uid
        let user = try await usersRepository
            .checkIfUserExists(fromProviderID: providerID)
        if let user = user {
            //existing user
            setCurrentUser(user)
            return LoginResult.existsUser(user: user)
        } else {
            //new user
            return LoginResult.newUser(providerID: providerID, result: result)
        }
    }
    
    // MARK: Anonymous sign in
    /// Sign in with anonymous
    /// After succeeded, call `createProfile` to create user account.
    func signUpAsAnonymous() async throws -> String {
        let result = try await Auth.auth().signInAnonymously()
        let userId = result.user.uid
        //Don't call `setUserID(:) here. Save it after profile is created.
        return userId
    }
    
    // MARK: Create
    /// Create user to database, return the created user
    func createNewUser(
        name: String,
        email: String,
        providerID: String,
        provider: String,
        profileImage: UIImage
    ) async throws -> User {
        let user = try await usersRepository.createNewUser(
            name: name,
            email: email,
            providerID: providerID,
            provider: provider,
            profileImage: profileImage
        )
        setCurrentUser(user)
        return user
    }
}

