//
//  DogGramUserDefaults.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation

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
    @StoredValue(key: "userID", defaultValue: nil)
    static var currentUserID: String?
}
