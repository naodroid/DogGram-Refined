//
//  OnBoardingViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class OnBoardingViewModel: ObservableObject {
    
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published private(set) var userID: String?
    @Published private(set) var provider: String?
    @Published var imageSelected: UIImage = UIImage(named: "logo")!
    @Published var showError: Bool = false
    @Published var showOnBoardingPart2: Bool = false
    @Published private(set) var dismiss: Bool = false
    
    
    private let appModule: AppModule
    private var authRepository: AuthRepository { appModule.authRepository }
    private var usersRepository: UsersRepository { appModule.usersRepository }
    
    private var cancellableList: [AnyCancellable] = []
    
    init(appModule: AppModule) {
        self.appModule = appModule
    }
    func onAppear() {
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }
    
    
    // MARK: SignIn/Up (for OnBoardingPart1)
    func signInWithApple() {
        commonSignIn(signInProcess: authRepository.startSignInWithApple)
    }
    func signInWithGoogle() {
        commonSignIn(signInProcess: authRepository.startSignINWithGoogle)
    }
    private func commonSignIn(
        signInProcess: @escaping () async throws -> LoginResult
    ) {
        Task {
            do {
                let result = try await signInProcess()
                switch result {
                case .existsUser(_):
                    self.dismiss = true
                case .newUser(let userID, let result):
                    self.userID = userID
                    self.email = result.email
                    self.displayName = result.name
                    self.provider = result.provider
                    self.showOnBoardingPart2 = true
                }
            } catch {
            }
        }.store(in: &cancellableList)
    }
    
    func signUpAsAnonymous() {
        Task {
            do {
                self.userID = try await authRepository.signUpAsAnonymous()
                self.email = ""
                self.displayName = ""
                self.provider = "anonymous"
                self.showOnBoardingPart2 = true
            } catch {
            }
        }
    }
    
    // MARK: Create user (for OnBoardingPart2)
    func createProfile() {
        guard let provider = provider, let userID = userID else {
            print("Need to login/signup first")
            return
        }
        Task {
            do {
                let _ = try await authRepository.createNewUser(
                    userID: userID,
                    name: displayName,
                    email: email,
                    provider: provider,
                    profileImage: imageSelected
                )
                //finished
                self.dismiss = true
            } catch {
                print("Error craeting user in firebase: \(error)")
                self.showError = true
            }
        }.store(in: &cancellableList)
    }
}
