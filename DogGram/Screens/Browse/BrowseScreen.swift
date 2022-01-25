//
//  BrowseScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/24.
//

import Foundation
import SwiftUI

@MainActor
struct BrowseScreen: View {
    @Environment(\.appModule) var appModule
    
    var body: some View {
        _BrowseScreen(
            appModule: appModule
        )
    }
}
@MainActor
private struct _BrowseScreen: View {
    @State private var viewModel: BrowseViewModel
    
    init(appModule: AppModule) {
        self._viewModel = State(
            wrappedValue: BrowseViewModel(
                appModule: appModule
            )
        )
    }
    
    var body: some View {
        BrowseView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
