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
final class SettingsViewModel: ObservableObject, UseCasesModuleUsing {
    let appModule: AppModule
    
    //
    @Published private(set) var user: User?
    @Published var showSignOutError: Bool = false
    @Published var showDeletingAccountError: Bool = false
    @Published var showEditingFinishedAlert = false
    @Published var requireDismiss = false
    //
    private var cancellableList: [AnyCancellable] = []
    

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
        requireDismiss = false
        Task {
            self.user = await ownerUseCase.currentUser
        }.store(in: &cancellableList)
        
        EventDispatcher.stream.sink { event in
            Task {
                self.on(event: event)
            }
        }.store(in: &cancellableList)
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }

    // MARK: Event Handling
    private func on(event: Event) {
        switch event {
        case .onCurrentUserChanged(let user):
            Task {
                self.user = user
            }.store(in: &cancellableList)
        case .onPostsUpdated:
            break
        }
    }
    
    // MARK: Profile
    func update(displayName: String? = nil, bio: String? = nil) {
        if displayName == nil && bio == nil {
            return
        }
        Task {
            do {
                _ = try await ownerUseCase.update(displayName: displayName, bio: bio)
                showEditingFinishedAlert = true
                print("FINISHED")
            } catch {
                print("ERROR \(error)")
            }
        }.store(in: &cancellableList)
    }
    
    func signOut() {
        Task {
            do {
                try await ownerUseCase.signOut()
                requireDismiss = true
            } catch {
                showSignOutError = true
            }
        }.store(in: &cancellableList)
    }
    func deleteAccount() {
        Task {
            do {
                try await ownerUseCase.deleteAccount()
                requireDismiss = true
            } catch {
                showDeletingAccountError = true
            }
        }.store(in: &cancellableList)
    }
    
    // MARK: Others
    func postFeedback(email: String?, message: String) {
        Task {
            do {
                try await feedbackUseCase.postFeedback(email: email, message: message)
            } catch {
                //TODO: error handling
            }
        }.store(in: &cancellableList)
    }
}
