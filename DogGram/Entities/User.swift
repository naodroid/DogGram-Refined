//
//  User.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import FirebaseFirestore

/// User Data stored in firebase
struct User {
    var displayName: String
    var email: String
    var providerId: String
    var provider: String
    var userID: String
    var bio: String
    var dateCreated: String? // if nil, send FieldValue.serverTimestamp
    
    
    struct Keys {
        static let displayName: String = "display_name"
        static let email: String = "email"
        static let providerId: String = "provider_id"
        static let provider: String = "provider"
        static let userID: String = "user_id"
        static let bio: String = "bio"
        static let dateCreated: String = "date_created"
    }
    
    init(
        displayName: String,
        email: String,
        providerId: String,
        provider: String,
        userID: String,
        bio: String,
        dateCreated: String?
    ) {
        self.displayName = displayName
        self.email = email
        self.providerId = providerId
        self.provider = provider
        self.userID = userID
        self.bio = bio
        self.dateCreated = dateCreated
    }
    
    
    init?(from document: DocumentSnapshot) {
        guard
            let displayName = document.get(Keys.displayName) as? String,
            let userID = document.get(Keys.userID) as? String else {
            return nil
        }
        self.displayName = displayName
        self.email = document.get(Keys.email) as? String ?? ""
        self.providerId = document.get(Keys.providerId) as? String ?? ""
        self.provider = document.get(Keys.provider) as? String ?? ""
        self.userID = userID
        self.bio = document.get(Keys.bio) as? String ?? ""
        self.dateCreated = document.get(Keys.dateCreated) as? String ?? ""
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            Keys.displayName: displayName,
            Keys.email: email,
            Keys.providerId: providerId,
            Keys.provider: provider,
            Keys.userID: userID,
            Keys.bio: bio
        ]
        if let date = dateCreated {
            dict[Keys.dateCreated] = date
        } else {
            dict[Keys.dateCreated] = FieldValue.serverTimestamp
        }
        return dict
    }
}
