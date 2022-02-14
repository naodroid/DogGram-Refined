//
//  FirebaseRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct FirebaseRepository {
    public static let firestore = Firestore.firestore()
}
