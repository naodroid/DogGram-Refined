//
//  ProfileViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI


@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var isMyProfile: Bool = false
    @Published private(set) var user: User?
    @Published private(set) var profileImage: UIImage = UIImage(named: "logo.loading")!
    @Published private(set) var posts: [Post] = []
    @Published private(set) var fetchError: Error?
    
    private let profileType: ProfileViewType
    private(set) var userID: String?

    private let appModule: AppModule
    
    init(type: ProfileViewType, appModule: AppModule) {
        self.profileType = type
        self.appModule = appModule
    }
    
    
    func onAppear() {
        Task {
            switch profileType {
            case .topPage:
                self.userID = await appModule.authRepository.currentUserID
                print("USERID:\(self.userID)")
            case .specifiedUser(let userID):
                self.userID = userID
            }
            _ = await (self.getUserInfo(), self.getProfileImage())
        }
    }
    func onDisappear() {
        
    }
        
    private func getUserInfo() async {
        guard let userID = self.userID else {
            return
        }
        do {
            async let myID =  appModule.authRepository.currentUserID
            async let user =  appModule.usersRepository.getProfile(for: userID)
            self.isMyProfile = await myID == userID
            self.user = try await user
            // TODO: fetch posts
        } catch {
            self.fetchError = error
        }
    }
    private func getProfileImage() async {
        guard let userID = userID else {
            return
        }
        do {
            let image = try await appModule.imagesRepository.downloadProfileImage(userID: userID)
            self.profileImage = image
        } catch {
        }
    }
    
    ///
    func resetError() {
        fetchError = nil
    }
}
