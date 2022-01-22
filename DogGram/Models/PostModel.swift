//
//  PostModel.swift
//  DogGram
//
//  Created by naodroid on 2021/11/19.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable, Hashable {
    typealias ID = UUID
    var id = UUID()
    var postID: String
    var userID: String
    var username: String
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }    
}
