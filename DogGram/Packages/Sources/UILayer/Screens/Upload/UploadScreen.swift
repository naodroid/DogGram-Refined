//
//  UploadPostScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI
import DataLayer

@MainActor
struct UploadScreen: View {
    @Environment(\.appModule) var appModule
    
    init() {
    }
    
    var body: some View {
        _UploadScreen(appModule: appModule)
    }
}

@MainActor
private struct _UploadScreen: View {
    @State private var viewModel: UploadViewModel
    
    init(appModule: AppModule) {
        _viewModel = State(wrappedValue: UploadViewModel(appModule: appModule))
    }
    
    var body: some View {
        UploadView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
