//
//  CommentModel.swift
//  DogGram
//
//  Created by nao on 2021/11/19.
//

import Foundation
import SwiftUI

struct CommentModel: Identifiable, Hashable {
    typealias ID = UUID
    var id = UUID()
    var commentID: String
    var userID: String
    var username: String
    var content: String
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
