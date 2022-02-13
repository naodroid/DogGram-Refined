//
//  SettingsEditImageScreen.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import SwiftUI

@MainActor
struct SettingsEditImageScreen: View {
    @Environment(\.appModule) var appModule
    let title: String
    let description: String
    
    var body: some View {
        _SettingsEditImageScreen(
            appModule: appModule,
            title: title,
            description: description
        )
    }
}
@MainActor
private struct _SettingsEditImageScreen: View {
    @State private var viewModel: SettingsEditImageViewModel

    init(appModule: AppModule, title: String, description: String) {
        self._viewModel = State(
            wrappedValue: SettingsEditImageViewModel(
                appModule: appModule,
                title: title,
                description: description
            )
        )
    }
    
    var body: some View {
        SettingsEditImageView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
