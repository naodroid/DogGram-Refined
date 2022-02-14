//
//  SettingsScreen.swift
//  DogGram
//
//  Created by naodroid on 2022/01/25.
//

import Foundation
import SwiftUI
import DataLayer

@MainActor
struct SettingsScreen: View {
    @Environment(\.appModule) var appModule
    
    var body: some View {
        _SettingsScreen(
            appModule: appModule
        )
    }
}
@MainActor
private struct _SettingsScreen: View {
    @State private var viewModel: SettingsViewModel
    
    init(appModule: AppModule) {
        self._viewModel = State(
            wrappedValue: SettingsViewModel(
                appModule: appModule
            )
        )
    }
    
    var body: some View {
        SettingsView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
