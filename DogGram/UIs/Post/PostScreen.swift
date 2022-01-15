//
//  PostScreen.swift
//  DogGram
//
//  Created by nao on 2022/01/15.
//

import Foundation
import SwiftUI

@MainActor
struct PostScreen: View {
    @Environment(\.appModule) var appModule
    let post: Post
    let showHeaderAndFooler: Bool
    let addHeartAnimationToView: Bool
    
    var body: some View {
        _PostScreen(
            post: post,
            showHeaderAndFooler: showHeaderAndFooler,
            addHeartAnimationToView: addHeartAnimationToView,
            appModule: appModule
        )
    }
}
@MainActor
private struct _PostScreen: View {
    @State private var viewModel: PostViewModel
    let post: Post
    let showHeaderAndFooler: Bool
    let addHeartAnimationToView: Bool

    init(post: Post,
         showHeaderAndFooler: Bool,
         addHeartAnimationToView: Bool,
         appModule: AppModule) {
        self.post = post
        self.showHeaderAndFooler = showHeaderAndFooler
        self.addHeartAnimationToView = addHeartAnimationToView
        self._viewModel = State(wrappedValue: PostViewModel(post: post, appModule: appModule))
    }
    
    var body: some View {
        PostView(
            showHeaderAndFooter: showHeaderAndFooler,
            addHeartAnimationToView: addHeartAnimationToView
        ).environmentObject(viewModel)
    }
}
