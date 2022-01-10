//
//  ProfileViewModel.swift
//  DogGram
//
//  Created by nao on 2022/01/10.
//

import Foundation
import SwiftUI


enum ProfileViewType {
    case topPage
    case specifiedUser(userID: String)
}

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var isMyProfile: Bool = false
    @Published private(set) var user: User?
    @Published private(set) var profileImage: UIImage?
    @Published private(set) var posts: [PostModel] = []
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
            case .specifiedUser(let userID):
                self.userID = userID
            }
            await self.getUserInfo()
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
    
    ///
    func resetError() {
        fetchError = nil
    }
}
