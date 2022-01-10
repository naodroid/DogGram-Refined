//
//  SignInResult.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation
import FirebaseAuth

struct SignInResult {
    let email: String
    let name: String
    let provider: String
    let credential: AuthCredential
}

