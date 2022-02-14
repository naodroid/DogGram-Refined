//
//  Comment.swift
//  DogGram
//
//  Created by naodroid on 2022/01/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


public struct Comment: Identifiable, Codable, Hashable {
    @DocumentID public var id: String?
    public let userID: String
    public let displayName: String
    public let content: String
    public let dateCreated: Timestamp?
    public let likeCount: Int
    public let likedBy: [String] //listOfUserID
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case displayName = "display_name"
        case content = "content"
        case dateCreated = "date_created"
        case likeCount = "like_count"
        case likedBy = "liked_by"
    }
    
    static func decode(from document: DocumentSnapshot) -> Comment? {
        do {
            return try document.data(as: Comment.self)
        } catch {
            print("Post Decoding Error: \(error)")
            return nil
        }
    }
    static func decodeArray(from snapshot: QuerySnapshot?) -> [Comment] {
        guard let documents = snapshot?.documents else {
            return []
        }
        return documents.compactMap { s in
            return decode(from: s)
        }
    }

}
