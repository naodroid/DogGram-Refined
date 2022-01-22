//
//  Task.swift
//  DogGram
//
//  Created by naodroid on 2022/01/15.
//

import Foundation
import Combine

extension Task  {
// This extension causes build error.
//    static func delay(second: TimeInterval) async {
//        if second <= 0 {
//            return
//        }
//        let nano = UInt64(second * 1000 * 1000 * 1000)
//        try? await Task<Void, Never>.sleep(nanoseconds: nano)
//    }
    // Add the same methods as AnyCancellable
    func store<C>(in collection: inout C) where C : RangeReplaceableCollection, C.Element == AnyCancellable {
        let cancellable = AnyCancellable(self.cancel)
        collection.append(cancellable)
    }
    func store(in set: inout Set<AnyCancellable>) {
        let cancellable = AnyCancellable(self.cancel)
        set.insert(cancellable)
    }
}

// Use top-level function instead
func asyncSleep(for seconds: TimeInterval) async {
    if seconds <= 0 {
        return
    }
    let nano = UInt64(seconds * 1000 * 1000 * 1000)
    try? await Task.sleep(nanoseconds: nano)
}
