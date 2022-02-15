//
//  FirebaseRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirebaseRepository {
    static let firestore = Firestore.firestore()
}
