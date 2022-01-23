//
//  User.swift
//  DogGram
//
//  Created by naodroid on 2022/01/09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// User Data stored in firebase
struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var displayName: String
    var email: String
    var providerId: String
    var provider: String
    var bio: String
    @ServerTimestamp var dateCreated: Timestamp?
    
    enum Keys: String {
        case displayName = "displayName"
        case email = "email"
        case providerId = "providerId"
        case provider = "provider"
        case bio = "bio"
        case dateCreated = "dateCreated"
    }
    
    static func decode(from document: DocumentSnapshot) -> User? {
        do {
            return try document.data(as: User.self)
        } catch {
            print("User Decoding Error: \(error)")
            return nil
        }
    }
    static func decodeArray(from snapshot: QuerySnapshot?) -> [User] {
        guard let documents = snapshot?.documents else {
            return []
        }
        return documents.compactMap { d in
            decode(from: d)
        }
    }

}
