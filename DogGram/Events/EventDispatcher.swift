//
//  EventDispatcher.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation
import Combine

final class EventDispatcher {
    static let stream = PassthroughSubject<Event, Never>()
    
    static func post(event: Event) {
        Task.detached {
            await self._post(event: event)
        }
    }
    @MainActor
    private static func _post(event: Event) {
        stream.send(event)
    }
}
