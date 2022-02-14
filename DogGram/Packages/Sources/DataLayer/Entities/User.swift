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
public struct User: Codable, Identifiable {
    @DocumentID public var id: String?
    public var displayName: String
    public var email: String
    public var provider: String
    public var bio: String
    @ServerTimestamp public var dateCreated: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case email = "email"
        case provider = "provider"
        case bio = "bio"
        case dateCreated = "date_created"
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
