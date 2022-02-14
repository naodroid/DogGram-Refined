//
//  Feedback.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Feedback, used with post(encode) only. not used with get(decode)
public struct Feedback: Encodable, Identifiable {
    @DocumentID public var id: String?
    public let email: String?
    public let message: String
    @ServerTimestamp public var dateCreated: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email = "email"
        case message = "provider"
        case dateCreated = "date_created"
    }
}
