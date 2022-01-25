//
//  SettingsViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    
    //
    @Published private(set) var showSignOutError: Bool = false
    @Published private(set) var showDeletingAccountError: Bool = false
    @Published private(set) var user: User?
    @Published var showEditingFinishedAlert = false
    
    //
    private var cancellableList: [AnyCancellable] = []
    

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
        Task {
            self.user = await authRepository.currentUser
        }.store(in: &cancellableList)
        
        EventDispatcher.stream.sink { event in
            self.on(event: event)
        }.store(in: &cancellableList)
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }

    // MARK: Event Handling
    private func on(event: Event) {
        switch event {
        case .onUserChanged(let userID):
            Task {
                self.user = await authRepository.currentUser
            }.store(in: &cancellableList)
        case .onPostsUpdated:
            break
        }
    }
    
    // MARK: Profile
    func update(displayName: String) {
        
    }
}
