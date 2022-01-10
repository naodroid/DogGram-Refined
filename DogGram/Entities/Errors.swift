//
//  Errors.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation

enum AuthError: Error {
    case noCredential
    case noToken
    case parseError
    case noUserID
}
