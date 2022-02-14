//
//  SignInResult.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import FirebaseAuth

public struct SignInResult {
    public let email: String
    public let name: String
    public let provider: String
    public let credential: AuthCredential
}

