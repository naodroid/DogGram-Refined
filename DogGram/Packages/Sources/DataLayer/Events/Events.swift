//
//  Events.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation


public enum Event {
    case onCurrentUserChanged(user: User?)
    case onPostsUpdated(posts: [Post])
}
// 
public extension Event {
    func post() {
        EventDispatcher.post(event: self)
    }
}
