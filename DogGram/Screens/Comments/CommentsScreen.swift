//
//  CommentsScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation
import SwiftUI

@MainActor
struct CommentsScreen: View {
    @Environment(\.appModule) var appModule
    let post: Post
    
    var body: some View {
        _CommentsScreen(
            appModule: appModule,
            post: post
        )
    }
}
@MainActor
private struct _CommentsScreen: View {
    @State private var viewModel: CommentsViewModel
    
    init(appModule: AppModule, post: Post) {
        self._viewModel = State(
            wrappedValue: CommentsViewModel(
                appModule: appModule,
                post: post
            )
        )
    }
    
    var body: some View {
        CommentsView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
