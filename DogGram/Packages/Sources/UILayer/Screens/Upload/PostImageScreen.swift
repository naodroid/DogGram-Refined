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
struct PostImageScreen: View {
    @Environment(\.appModule) var appModule
    let imageSelected: UIImage
    
    init(imageSelected: UIImage) {
        self.imageSelected = imageSelected
    }
    
    var body: some View {
        _PostImageScreen(
            imageSelected: imageSelected,
            appModule: appModule
        )
    }
}

@MainActor
private struct _PostImageScreen: View {
    @State private var viewModel: PostImageViewModel
    let imageSelected: UIImage

    init(imageSelected: UIImage, appModule: AppModule) {
        self.imageSelected = imageSelected
        _viewModel = State(wrappedValue:
                            PostImageViewModel(
                                imageSelected: imageSelected,
                                appModule: appModule
                            )
        )
    }
    
    var body: some View {
        PostImageView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}

