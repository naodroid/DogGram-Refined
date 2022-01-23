//
//  Post.swift
//  DogGram
//
//  Created by naodroid on 2022/01/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var dateCreated: Timestamp?
    let userID: String
    let displayName: String
    let caption: String?
    var likeCount: Int
    var likedBy: [String]
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case displayName = "display_name"
        case caption = "caption"
        case likeCount = "like_count"
        case likedBy = "liked_by"
        case comments = "comments"
    }
    
    static func decodeArray(snapshot: QuerySnapshot?) -> [Post] {
        guard let documents = snapshot?.documents else {
            return []
        }
        let decoder =  Firestore.Decoder()
        return documents.compactMap { s in
            print(s.data())
            do {
                return try decoder.decode(Post.self, from: s.data())
            } catch {
                print(error)
                return nil
            }
        }
    }
}

