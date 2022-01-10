//
//  OnBoardingViewModel.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class OnBoardingViewModel: ObservableObject {
    
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published private(set) var providerID: String = ""
    @Published private(set) var provider: String = ""
    @Published var imageSelected: UIImage = UIImage(named: "logo")!
    @Published var showError: Bool = false
    @Published var showOnBoardingPart2: Bool = false
    @Published private(set) var dismiss: Bool = false
    
    
    private let appModule: AppModule
    private var authRepository: AuthRepository { appModule.authRepository }
    private var usersRepository: UsersRepository { appModule.usersRepository }
    
    
    init(appModule: AppModule) {
        self.appModule = appModule
    }
    
    func createProfile() {
        print("CREATE PROFILE")
        AuthService.instance.createNewUserInDatabase(
            name: displayName,
            email: email,
            providerID: providerID,
            provider: provider,
            profileImage: imageSelected
        ) { userID in
            if let userID = userID {
                AuthService.instance.loginUserToApp(userID: userID) { success in
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dismiss = true
                        }
                    } else {
                        self.showError = true
                    }
                }
            } else {
                print("Error craeting user in firebase")
                self.showError = true
            }
        }
    }
    
    
    // MARK: SignIn/Up
    
    func signInWithApple() {
        commonSignIn(signInProcess: authRepository.startSignInWithApple)
    }
    func signInWithGoogle() {
        commonSignIn(signInProcess: authRepository.startSignINWithGoogle)
    }
    private func commonSignIn(
        signInProcess: @escaping () async throws -> SignInResult
    ) {
        Task {
            do {
                let result = try await signInProcess()
                let providerID = try await authRepository.logInUserToFirebase(credential: result.credential)
                let existingUserID = try await usersRepository.checkIfUserExistsInDatabase(providerID: providerID)
                if let userID = existingUserID {
                    //existing user
                    await authRepository.setUserID(userID)
                    self.dismiss = true
                } else {
                    //new user
                    self.email = result.email
                    self.displayName = result.name
                    self.provider = result.provider
                    self.providerID = providerID
                    self.showOnBoardingPart2 = true
                }
            } catch {
            }
        }
    }
    
    
    func signUpAsAnnonymous() {
        Task {
            try await authRepository.signUpAsAnnonymous()
            self.email = ""
            self.displayName = ""
            self.provider = "annonymous"
            self.providerID = ""
            self.showOnBoardingPart2 = true
        }
    }
}
