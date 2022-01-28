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
        case id
        case userID = "user_id"
        case displayName = "display_name"
        case caption = "caption"
        case likeCount = "like_count"
        case likedBy = "liked_by"
        case comments = "comments"
        case dateCreated = "date_created"
    }
    
    static func decode(from document: DocumentSnapshot) -> Post? {
        do {
            return try document.data(as: Post.self)
        } catch {
            print("Post Decoding Error: \(error)")
            return nil
        }
    }
    static func decodeArray(from snapshot: QuerySnapshot?) -> [Post] {
        guard let documents = snapshot?.documents else {
            return []
        }
        return documents.compactMap { s in
            return decode(from: s)
        }
    }
}
extension Array where Element == Post {
    mutating func merge(_ posts: [Post]) {
        for (index, p1) in self.enumerated() {
            for p2 in posts {
                if p1.id == p2.id {
                    self[index] = p2
                    break
                }
            }
        }

    }
}

