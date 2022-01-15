//
//  User.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import FirebaseFirestore

/// User Data stored in firebase
struct User: Codable {
    var displayName: String
    var email: String
    var providerId: String
    var provider: String
    var userID: String
    var bio: String
    var dateCreated: Timestamp? // if nil, send FieldValue.serverTimestamp
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case email = "email"
        case providerId = "provider_id"
        case provider = "provider"
        case userID = "user_id"
        case bio = "bio"
        case dateCreated = "date_created"
    }
}
