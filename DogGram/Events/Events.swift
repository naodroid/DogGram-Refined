//
//  Events.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation


enum Event {
    case onUserChanged(userID: String?)
}
// 
extension Event {
    func post() {
        EventDispatcher.post(event: self)
    }
}
