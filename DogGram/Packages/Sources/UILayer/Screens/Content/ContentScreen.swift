//
//  ContentScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI
import DataLayer

// Entry point
@MainActor
public struct ContentScreen: View {
    @Environment(\.appModule) var appModule
    
    public init() {
    }
    
    public var body: some View {
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
