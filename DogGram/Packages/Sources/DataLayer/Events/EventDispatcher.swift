//
//  EventDispatcher.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import Combine

public final class EventDispatcher {
    public static let stream = PassthroughSubject<Event, Never>()
    
    public static func post(event: Event) {
        Task.detached {
            await self._post(event: event)
        }
    }
    @MainActor
    private static func _post(event: Event) {
        stream.send(event)
    }
}
