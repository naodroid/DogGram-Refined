//
//  FeedScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/18.
//

import Foundation
import SwiftUI
import DataLayer

@MainActor
struct FeedScreen: View {
    @Environment(\.appModule) var appModule
    let title: String
    
    var body: some View {
        _FeedScreen(
            title: title,
            appModule: appModule
        )
    }
}
@MainActor
private struct _FeedScreen: View {
    @State private var viewModel: FeedViewModel
    let title: String
    
    init(title: String,
         appModule: AppModule) {
        self.title = title
        self._viewModel = State(wrappedValue: FeedViewModel(appModule: appModule))
    }
    
    var body: some View {
        FeedView(title: title)
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
