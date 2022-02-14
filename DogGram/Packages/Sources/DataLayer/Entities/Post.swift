//
//  Post.swift
//  DogGram
//
//  Created by naodroid on 2022/01/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Post: Codable, Hashable, Identifiable {
    @DocumentID public var id: String?
    @ServerTimestamp public var dateCreated: Timestamp?
    public let userID: String
    public let displayName: String
    public let caption: String?
    public var likeCount: Int
    public var likedBy: [String]
    public var comments: [Comment]
    
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
    
    /// if creating `init(..)`, `init(decoder:)` will also be required.
    /// create static initializer to avoid it
    public static func create(
        id: String? = nil,
        dateCreated: Timestamp? = nil,
        userID: String,
        displayName: String = "",
        caption: String? = nil,
        likeCount: Int = 0,
        likedBy: [String] = [],
        comments: [Comment] = []
    ) -> Post {
        return Post(
            id: id,
            dateCreated: dateCreated,
            userID: userID,
            displayName: displayName,
            caption: caption,
            likeCount: likeCount,
            likedBy: likedBy,
            comments: comments
        )
    }
}
public extension Array where Element == Post {
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

