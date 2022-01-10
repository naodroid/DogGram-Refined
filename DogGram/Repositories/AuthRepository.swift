//
//  UsersRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

enum LoginResult {
    case existsUser(providerID: String, userID: String)
    case newUser(providerID: String)
}

/// Manage user info related to owner
actor AuthRepository {
    
    private(set) var currentUserID: String?
    private let signInWithApple = SignInWithApple()
    private let signInWithGoole = SignInWithGoogle()
    ///
    nonisolated init() {
        currentUserID = DogGramStorage.currentUserID
    }
    
    func setUserID(_ userID: String?) {
        currentUserID = userID
        DogGramStorage.currentUserID = userID
        Event.onUserChanged(userID: userID).post()
    }
    
    /// Start SignIn With apple
    func startSignInWithApple() async throws -> SignInResult {
        return try await signInWithApple.start()
    }
    func startSignINWithGoogle() async throws -> SignInResult {
        return try await signInWithGoole.start()
    }
    
    func signUpAsAnnonymous() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signInAnonymously { authResult, error in
                guard authResult?.user != nil else {
                    let e = error ?? NSError()
                    continuation.resume(throwing: e)
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
    
    
    /// login to firebase and get ProviderID
    func logInUserToFirebase(credential: AuthCredential) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let providerID = result?.user.uid else {
                    continuation.resume(throwing: AuthError.noUserID)
                    return
                }
                continuation.resume(returning: providerID)
            }
        }
    }
}

