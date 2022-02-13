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
struct Feedback: Encodable, Identifiable {
    @DocumentID var id: String?
    var email: String?
    var message: String
    @ServerTimestamp var dateCreated: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email = "email"
        case message = "provider"
        case dateCreated = "date_created"
    }
}
