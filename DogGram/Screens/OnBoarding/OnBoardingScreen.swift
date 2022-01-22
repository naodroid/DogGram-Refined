//
//  OnBoardingScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI

@MainActor
struct OnBoardingScreen: View {
    @Environment(\.appModule) var appModule
    var body: some View {
        _OnBoardingScreen(appModule: appModule)
    }
}
@MainActor
private struct _OnBoardingScreen: View {
    @State private var viewModel: OnBoardingViewModel
    
    init(appModule: AppModule) {
        _viewModel = State(wrappedValue: OnBoardingViewModel(appModule: appModule))
    }
    
    var body: some View {
        OnBoardingView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
