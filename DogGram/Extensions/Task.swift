//
//  Task.swift
//  DogGram
//
//  Created by nao on 2022/01/15.
//

import Foundation

// This extension causes build error.
//extension Task  {
//    static func delay(second: TimeInterval) async {
//        if second <= 0 {
//            return
//        }
//        let nano = UInt64(second * 1000 * 1000 * 1000)
//        try? await Task<Void, Never>.sleep(nanoseconds: nano)
//    }
//}

// Use top-level function instead
func asyncSleep(for seconds: TimeInterval) async {
    if seconds <= 0 {
        return
    }
    let nano = UInt64(seconds * 1000 * 1000 * 1000)
    try? await Task.sleep(nanoseconds: nano)
}
