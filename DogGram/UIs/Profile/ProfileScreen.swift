//
//  ProfileScreen.swift
//  DogGram
//
//  Created by nao on 2022/01/11.
//

import Foundation
import SwiftUI

@MainActor
struct ProfileScreen: View {
    @Environment(\.appModule) var appModule
    let type: ProfileViewType
    
    init(type: ProfileViewType) {
        self.type = type
    }
    
    var body: some View {
        _ProfileScreen(type: type, appModule: appModule)
    }
}

@MainActor
private struct _ProfileScreen: View {
    @State private var viewModel: ProfileViewModel
    
    init(type: ProfileViewType, appModule: AppModule) {
        _viewModel = State(wrappedValue: ProfileViewModel(type: type, appModule: appModule))
    }
    
    var body: some View {
        ProfileView()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
