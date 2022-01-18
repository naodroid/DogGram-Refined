//
//  EnumsAndStructs.swift
//  DogGram
//
//  Created by nao on 2021/12/18.
//

import Foundation

struct DatabaseUserField {
    static let displayName: String = "display_name"
    static let email: String = "email"
    static let providerId: String = "provider_id"
    static let provider: String = "provider"
    static let userID: String = "user_id"
    static let bio: String = "bio"
    static let dateCreated: String = "date_created"
}

struct DatabasePostField {
    static let postID: String = "post_id"
    static let userID: String = "user_id"
    static let displayName: String = "display_name"
    static let caption: String = "caption"
    static let dateCreated: String = "date_created"
    static let likeCount: String = "like_count"
    static let likedBy: String = "liked_by"
    static let comments: String = "comments" // sub collection
}

struct DatabaseCommentField {
    static let commentID: String = "post_id"
    static let userID: String = "user_id"
    static let displayName: String = "display_name"
    static let content: String = "content" // sub collection
    static let dateCreated: String = "date_created"
    static let likeCount: String = "like_count"
    static let likedBy: String = "liked_by"
}




struct DatabaseReportField {
    static let postID: String = "post_id"
    static let content: String = "content"
    static let dateCreated: String = "date_created"
}
struct DatabaseFeedbackFeed {
    static let email: String = "email"
    static let message: String = "message"
}


struct CurrentUserDefaults {
    static let displayName: String = "display_name"
    static let userID: String = "user_id"
    static let bio: String = "bio"
}
