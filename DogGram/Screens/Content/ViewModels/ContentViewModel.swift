//
//  ContentViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ContentViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    @Published private(set) var userLoggedIn = false
    private var cancellableList: [AnyCancellable] = []

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
        Task {
            userLoggedIn = await authRepository.currentUser != nil
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
            userLoggedIn = userID != nil
        case .onPostsUpdated:
            break
        }
    }
}
