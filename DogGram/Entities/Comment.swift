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
    let commentID: String
    let userID: String
    let displayName: String
    let content: String
    let dateCreated: Timestamp?
    let likeCount: Int
    let likedBy: [String] //listOfUserID
    var id: String { commentID }
    
    enum CodingKeys: String, CodingKey {
        case commentID = "post_id"
        case userID = "user_id"
        case displayName = "display_name"
        case content = "content"
        case dateCreated = "date_created"
        case likeCount = "like_count"
        case likedBy = "liked_by"
    }
}
