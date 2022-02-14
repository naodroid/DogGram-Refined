//
//  ContentViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI
import Combine
import DataLayer
import DomainLayer

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
            userLoggedIn = await ownerUseCase.currentUser != nil
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
        case .onCurrentUserChanged(let user):
            userLoggedIn = user != nil
        case .onPostsUpdated:
            break
        }
    }
}
