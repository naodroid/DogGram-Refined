//
//  Post.swift
//  DogGram
//
//  Created by nao on 2022/01/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Codable, Hashable {
    var id: String?
    let postID: String
    let userID: String
    let displayName: String
    let caption: String?
    let dateCreated: Timestamp?
    var likeCount: Int
    var likedBy: [String]
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case userID = "user_id"
        case displayName = "display_name"
        case caption = "caption"
        case dateCreated = "date_created"
        case likeCount = "like_count"
        case likedBy = "liked_by"
        case comments = "comments"
    }
    
    static func decode(snapshot: QuerySnapshot?) -> [Post] {
        guard let documents = snapshot?.documents else {
            return []
        }
        let decoder =  Firestore.Decoder()
        return documents.compactMap { s in
            return try? decoder.decode(Post.self, from: s.data())
        }
    }
}

