//
//  UsersRepository.swift
//  DogGram
//
//  Created by naodroid on 2022/01/09.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UsersRepository {
    func createNewUser(userID: String,
                       name: String,
                       email: String,
                       provider: String) async throws -> User
    
    func checkIfUserExists(fromUserID userID: String) async throws -> User?

    // Delete
    func deleteUser(userID: String) async throws
    
    // Profile
    func getProfile(for userID: String) async throws -> User
    func updateProfile(for user: User) async throws
    
}

/// Repository for users
public actor UsersRepositoryImpl: UsersRepository {
    private static let firestore = Firestore.firestore()
    private let usersRef = UsersRepositoryImpl.firestore.collection("users")
    
    ///
    public nonisolated init() {
    }
    
    /// Create New User With passed information
    /// - Parameters:
    ///   - userID: The id from FirebaseAuth.user.id
    /// - Returns: Created UserID
    public func createNewUser(
        userID: String,
        name: String,
        email: String,
        provider: String
    ) async throws -> User {
        let document = usersRef.document(userID)
        //set user data
        let user = User(
            id: userID,
            displayName: name,
            email: email,
            provider: provider,
            bio: "",
            dateCreated: nil)
        try await document.setDataAsync(from: user)
        return user
    }
    
    /// returns user if exists. if not exists, return nil
    /// - Parameter fromProviderID: providerID
    public func checkIfUserExists(fromUserID userID: String) async throws -> User? {
        let documents = try await usersRef.document(userID).getDocument()
        let user = User.decode(from: documents)
        return user
    }
    
    public func deleteUser(userID: String) async throws {
        try await usersRef.document(userID).delete()        
    }

    
    
    // MARK: fetch
    public func getProfile(for userID: String) async throws -> User {
        let snapshot = try await usersRef.document(userID).getDocument()
        guard let user = User.decode(from: snapshot) else {
            //TODO: create custom error type
            throw NSError()
        }
        return user
    }
    
    
    // MARK: Update
    public func updateProfile(for user: User) async throws {
        guard let id = user.id else {
            throw NSError(domain: "Invalid user", code: -1, userInfo: nil)
        }
        try await usersRef.document(id).setDataAsync(from: user)
    }
}


