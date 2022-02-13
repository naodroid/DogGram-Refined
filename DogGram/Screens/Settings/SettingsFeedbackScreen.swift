//
//  SettingsFeedbackScreen.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import SwiftUI

@MainActor
struct SettingsFeedbackScreen: View {
    @Environment(\.appModule) var appModule
    
    var body: some View {
        _SettingsFeedbackScreen(
            appModule: appModule
        )
    }
}
@MainActor
private struct _SettingsFeedbackScreen: View {
    @State private var viewModel: SettingsFeedbackViewModel
    
    init(appModule: AppModule) {
        self._viewModel = State(
            wrappedValue: SettingsFeedbackViewModel(
                appModule: appModule
            )
        )
    }
    
    var body: some View {
        SettingsFeedbackView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
