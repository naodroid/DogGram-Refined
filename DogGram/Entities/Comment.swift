//
//  Comment.swift
//  DogGram
//
//  Created by naodroid on 2022/01/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Comment: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let userID: String
    let displayName: String
    let content: String
    let dateCreated: Timestamp?
    let likeCount: Int
    let likedBy: [String] //listOfUserID
    
    enum Keys: String {
        case id
        case userID = "user_id"
        case displayName = "display_name"
        case content = "content"
        case dateCreated = "date_created"
        case likeCount = "like_count"
        case likedBy = "liked_by"
    }
}
