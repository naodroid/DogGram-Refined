//
//  UsersRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


/// Repository for users
actor UsersRepository {
    private static let firestore = Firestore.firestore()
    private let usersRef = UsersRepository.firestore.collection("users")
    private let imageRepository: ImagesRepository!
    ///
    nonisolated init(imageRepository: ImagesRepository) {
        self.imageRepository = imageRepository
    }
    
    /// Create New User With passed information
    /// - Returns: Created UserID
    func createNewUser(
        name: String,
        email: String,
        providerID: String,
        provider: String,
        profileImage: UIImage
    ) async throws -> String {
        let document = usersRef.document()
        let userID = document.documentID
        
        try await imageRepository.uploadProfileImage(userID: userID, image: profileImage)
        //set user data
        let user = User(displayName: name,
                        email: email,
                        providerId: providerID,
                        provider: provider,
                        userID: userID,
                        bio: "",
                        dateCreated: nil)
        return try await withCheckedThrowingContinuation { continuation in
            document.setData(user.toDict()) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: userID)
            }
        }
    }
    
    /// returns userID if exists. if not exists, retuns nil
    /// - Parameter providerID: providerID
    func checkIfUserExistsInDatabase(providerID: String) async throws -> String? {
        // If a userID is returned, then the user does exist in our database
        return try await withCheckedThrowingContinuation { continuation in
            usersRef.whereField(User.Keys.userID, isEqualTo: providerID)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let snapshot = snapshot,
                       snapshot.count > 1,
                       let document = snapshot.documents.first {
                        let existingUserID = document.documentID
                        continuation.resume(returning: existingUserID)
                        return
                    }
                    continuation.resume(returning: nil)
                }
        }
    }
    
    
    // MARK: fetch
    func getProfile(for userID: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            usersRef.document(userID).getDocument { snapshot, error in
                if let document = snapshot,
                   let user = User(from: document) {
                    continuation.resume(returning: user)
                } else {
                    let e = error ?? NSError()
                    continuation.resume(throwing: e)
                }
            }
        }
    }
}

