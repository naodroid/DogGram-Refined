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
    
    enum Keys: String {
        case commentID = "postId"
        case userID = "userId"
        case displayName = "displayName"
        case content = "content"
        case dateCreated = "dateCreated"
        case likeCount = "likeCount"
        case likedBy = "likedBy"
    }
}
