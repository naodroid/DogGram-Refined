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
    case newUser(userID: String, result: SignInResult)
}


/// Manage user info related to owner
actor AuthRepository {
    
    private(set) var currentUser: User?
    var currentUserID: String? {
        currentUser?.id
    }
    
    private let signInWithApple = SignInWithApple()
    private let signInWithGoole = SignInWithGoogle()

    private let usersRepository: UsersRepository
    private let imagesRepository: ImagesRepository
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private var cache: [String: Post] = [:]
    
    nonisolated init(usersRepository: UsersRepository,
                     imagesRepository: ImagesRepository) {
        self.usersRepository = usersRepository
        self.imagesRepository = imagesRepository
        self.currentUser = DogGramStorage.currentUser
        
        if let user = Auth.auth().currentUser,
           self.currentUser?.id != user.uid {
            //TODO: Check UserID is valid or not
        }
    }
    
    
    // MARK: Manage current user
    private func listenState() {
        authHandle = Auth.auth().addStateDidChangeListener {[weak self] auth, user in
            guard let self = self else {
                return
            }
            Task {
                await self.onStateChanged(auth: auth, user: user)
            }
        }
    }
    private func onStateChanged(auth: Auth, user: FirebaseAuth.User?) {
        guard let user = user else {
            self.setCurrentUser(nil)
            return
        }
        if user.uid == self.currentUser?.id {
            //TODO: update info
        } else {
            //switch to new user
            
        }
    }
    
    
    
    private func setCurrentUser(_ user: User?) {
        self.currentUser = user
        DogGramStorage.currentUser = user
        Event.onCurrentUserChanged(user: user).post()
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
        let userID = ret.user.uid
        let user = try await usersRepository
            .checkIfUserExists(fromUserID: userID)
        if let user = user {
            //existing user
            setCurrentUser(user)
            return LoginResult.existsUser(user: user)
        } else {
            //new user
            return LoginResult.newUser(userID: userID, result: result)
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
        userID: String,
        name: String,
        email: String,
        provider: String,
        profileImage: UIImage
    ) async throws -> User {
        let user = try await usersRepository.createNewUser(
            userID: userID,
            name: name,
            email: email,
            provider: provider,
            profileImage: profileImage
        )
        setCurrentUser(user)
        return user
    }
    
    // MARK: Profile
    func update(displayName: String? = nil,
                bio: String? = nil) async throws -> User? {
        guard
            var user = currentUser,
            user.id != nil
        else {
            return currentUser
        }
        
        if let name = displayName {
            user.displayName = name
        }
        if let bio = bio {
            user.bio = bio
        }
        try await usersRepository.updateProfile(for: user)
        setCurrentUser(user)
        return user
    }
}

