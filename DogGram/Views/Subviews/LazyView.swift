//
//  LazyView.swift
//  DogGram
//
//  Created by nao on 2022/01/01.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        return self.content()
    }
}
