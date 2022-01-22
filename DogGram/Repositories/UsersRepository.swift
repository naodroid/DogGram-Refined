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
    ) async throws -> User {
        let document = usersRef.document()
        let documentID = document.documentID
        
        try await imageRepository.uploadProfileImage(
            userID: documentID,
            image: profileImage
        )
        //set user data
        let user = User(
            documentID: documentID,
            displayName: name,
            email: email,
            providerId: providerID,
            provider: provider,
            bio: "",
            dateCreated: nil)
        try document.setData(from: user)
        return user
    }
    
    /// returns user if exists. if not exists, retun nil
    /// - Parameter fromProviderID: providerID
    func checkIfUserExists(fromProviderID providerID: String) async throws -> User? {
        let documents = try await usersRef.whereField(
            User.CodingKeys.providerId.rawValue,
            isEqualTo: providerID
        ).getDocuments()
        let users = User.decodeArray(snapshot: documents)
        return users.first
    }
    
    
    // MARK: fetch
    func getProfile(for userID: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            usersRef.document(userID).getDocument { snapshot, error in
                do {
                    if let data = snapshot?.data() {
                        let user = try Firestore.Decoder().decode(User.self, from: data, in: nil)
                        continuation.resume(returning: user)
                    } else {
                        throw NSError()
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


