//
//  DogGramUserDefaults.swift
//  DogGram
//
//  Created by naodroid on 2022/01/09.
//

import Foundation
import FirebaseFirestore

@propertyWrapper
struct StoredValue<T> {
    private let key: String
    private let defaultValue: T?
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct DogGramStorage {
    // This id doesn't need to be stored in defaults.
    // Use firebase instead.
    @StoredValue(key: "userID", defaultValue: nil)
    static var userID: String?
    @StoredValue(key: "userDisplayName", defaultValue: nil)
    static var userDisplayName: String?
    @StoredValue(key: "userEmail", defaultValue: nil)
    static var userEmail: String?
    @StoredValue(key: "userProvider", defaultValue: nil)
    static var userProvider: String?
    @StoredValue(key: "userBio", defaultValue: nil)
    static var userBio: String?
    @StoredValue(key: "userDateCreated", defaultValue: nil)
    static var userDateCreated: Date?
    
    
    
    static var currentUser: User? {
        get {
            guard
                let id = self.userID,
                let displayName = self.userDisplayName,
                let email = self.userEmail,
                let provider = self.userProvider,
                let bio = self.userBio else {
                    return nil
                }
            let dateCreated = self.userDateCreated ?? Date()
            let timestamp = Timestamp(date: dateCreated)
            return User(
                id: id,
                displayName: displayName,
                email: email,
                provider: provider,
                bio: bio,
                dateCreated: timestamp
            )
        }
        set {
            guard let user = newValue else {
                self.userID = nil
                self.userDisplayName = nil
                self.userEmail = nil
                self.userProvider = nil
                self.userBio = nil
                self.userDateCreated = nil
                return
            }
            self.userID = user.id
            self.userDisplayName = user.displayName
            self.userEmail = user.email
            self.userProvider = user.provider
            self.userBio = user.bio
            self.userDateCreated = user.dateCreated?.dateValue()
        }
    }
}
