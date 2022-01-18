//
//  AnyCancellable+Ext.swift
//  DogGram
//
//  Created by nao on 2022/01/18.
//

import Foundation
import Combine

extension Array where Element == AnyCancellable {
    
    mutating func cancelAll() {
        let list = self
        self.removeAll()
        list.forEach {
            $0.cancel()
        }
    }
}
