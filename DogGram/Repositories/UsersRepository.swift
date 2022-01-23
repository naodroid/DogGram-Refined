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
            id: documentID,
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
        let snapshot = try await usersRef.document(userID).getDocument()
        guard let data = snapshot.data() else {
            //TODO: create custom error type
            throw NSError()
        }
        var user: User = try Firestore.Decoder().decode(User.self, from: data, in: nil)
        user.id = userID //Firebase didn't put userID, instead put it own
        return user
    }
}


