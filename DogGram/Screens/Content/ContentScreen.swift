//
//  ContentScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI

@MainActor
struct ContentScreen: View {
    @Environment(\.appModule) var appModule
    
    var body: some View {
        _ContentScreen(
            appModule: appModule
        )
    }
}
@MainActor
private struct _ContentScreen: View {
    @State private var viewModel: ContentViewModel
    
    init(appModule: AppModule) {
        self._viewModel = State(
            wrappedValue: ContentViewModel(
                appModule: appModule
            )
        )
    }
    
    var body: some View {
        ContentView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
