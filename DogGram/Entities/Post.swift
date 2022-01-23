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
    
    enum Keys: String {
        case userID = "userId"
        case displayName = "displayName"
        case caption = "caption"
        case likeCount = "likeCount"
        case likedBy = "likedBy"
        case comments = "comments"
        case dateCreated = "dateCreated"
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

