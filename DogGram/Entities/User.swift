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
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case email = "email"
        case providerId = "provider_id"
        case provider = "provider"
        case bio = "bio"
        case dateCreated = "date_created"
    }
    
    static func decodeArray(snapshot: QuerySnapshot?) -> [User] {
        guard let documents = snapshot?.documents else {
            return []
        }
        let decoder =  Firestore.Decoder()
        return documents.compactMap { s in
            do {
                return try decoder.decode(User.self, from: s.data())
            } catch {
                return nil
            }
        }
    }

}
