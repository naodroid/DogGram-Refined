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
    @StoredValue(key: "documentID", defaultValue: nil)
    static var userDocumentID: String?
    @StoredValue(key: "displayName", defaultValue: nil)
    static var userDisplayName: String?
    @StoredValue(key: "email", defaultValue: nil)
    static var userEmail: String?
    @StoredValue(key: "providerId", defaultValue: nil)
    static var userProviderId: String?
    @StoredValue(key: "provider", defaultValue: nil)
    static var userProvider: String?
    @StoredValue(key: "bio", defaultValue: nil)
    static var userBio: String?
    @StoredValue(key: "dateCreated", defaultValue: nil)
    static var userDateCreated: Date?
    
    
    
    static var currentUser: User? {
        get {
            guard
                let documentID = self.userDocumentID,
                let displayName = self.userDisplayName,
                let email = self.userEmail,
                let providerId = self.userProviderId,
                let provider = self.userProvider,
                let documentID = self.userDocumentID,
                let bio = self.userBio else {
                    return nil
                }
            let dateCreated = self.userDateCreated ?? Date()
            let timestamp = Timestamp(date: dateCreated)
            return User(
                documentID: documentID,
                displayName: displayName,
                email: email,
                providerId: providerId,
                provider: provider,
                bio: bio,
                dateCreated: timestamp
            )
        }
        set {
            guard let user = newValue else {
                self.userDocumentID = nil
                self.userDisplayName = nil
                self.userEmail = nil
                self.userProviderId = nil
                self.userProvider = nil
                self.userBio = nil
                self.userDateCreated = nil
                return
            }
            self.userDocumentID = user.documentID
            self.userDisplayName = user.displayName
            self.userEmail = user.email
            self.userProviderId = user.providerId
            self.userProvider = user.provider
            self.userBio = user.bio
            self.userDateCreated = user.dateCreated?.dateValue()
        }
    }
}
