//
//  SettingsFeedbackViewModel.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import SwiftUI
import Combine
import DataLayer
import DomainLayer

@MainActor
final class SettingsFeedbackViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    
    //
    @Published var emailText: String = ""
    @Published var message: String = ""
    @Published var showSuccessAlert: Bool = false
    //
    private var cancellableList: [AnyCancellable] = []
    

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
    }
    func onDisappear() {
    }

    // MARK: Profile
    func postFeedback() {
        Task {
            do {
                try await feedbackUseCase.postFeedback(email: self.emailText, message: self.message)
                self.showSuccessAlert = true
            } catch {
                //TODO: Error handling
            }
        }.store(in: &cancellableList)
    }
}

