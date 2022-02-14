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

public enum LoginResult {
    case existsUser(user: User)
    case newUser(userID: String, result: SignInResult)
}


/// Manage user info related to owner
public actor AuthRepository {
    
    public private(set) var currentUser: User?
    public var currentUserID: String? {
        currentUser?.id
    }
    
    private let signInWithApple = SignInWithApple()
    private let signInWithGoole = SignInWithGoogle()

    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private var cache: [String: Post] = [:]
    
    public nonisolated init() {
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
    
    public func setCurrentUser(_ user: User?) {
        self.currentUser = user
        DogGramStorage.currentUser = user
        Event.onCurrentUserChanged(user: user).post()
    }
    
    // MARK: Sign in with providers
    /// Start signin with apple
    /// After succeeded, call `createProfile` to create user account.
    public func startSignInWithApple() async throws -> SignInResult {
        return try await signInWithApple.start()
    }
    /// Start signin with google
    /// After succeeded, call `createProfile` to create user account.
    public func startSignInWithGoogle() async throws -> SignInResult {
        return try await signInWithGoole.start()
    }
    public func getFirebaseUserUID(result: SignInResult) async throws -> String {
        let user = try await Auth.auth().signIn(with: result.credential)
        return user.user.uid
    }
    
    // MARK: Anonymous sign in
    /// Sign in with anonymous
    /// After succeeded, call `createProfile` to create user account.
    public func signUpAsAnonymous() async throws -> String {
        let result = try await Auth.auth().signInAnonymously()
        let userId = result.user.uid
        //Don't call `setUserID(:) here. Save it after profile is created.
        return userId
    }
    
    public func signOut() async throws {
        try Auth.auth().signOut()
    }
}

