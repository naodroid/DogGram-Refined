//
//  Firestore+Ext.swift
//  DogGram
//
//  Created by naodroid on 2022/01/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public extension DocumentReference {
    func setDataAsync<T: Encodable>(from data: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try self.setData(
                    from: data,
                    encoder: Firestore.Encoder()) { error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: ())
                        }
                    }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
