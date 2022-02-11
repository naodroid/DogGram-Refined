//
//  PostImageViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine


enum PostImageAlertType {
    case postFinished
    case postFailed(message: String)
    case initializingFailed(message: String)
}

@MainActor
final class PostImageViewModel: ObservableObject, UseCasesModuleUsing, AppModuleUsing {
    //
    let imageSelected: UIImage
    let appModule: AppModule
    //
    @Published var captionText: String = ""
    @Published var user: User?
    @Published var alertType: PostImageAlertType? {
        didSet {
            if alertType != nil {
                showAlert = true
            }
        }
    }
    @Published var showAlert = false {
        didSet {
            if !showAlert {
                alertType = nil
            }
        }
    }
    
    
    private(set) var currentUserDisplayName: String?
    //
    private var cancellableList: [AnyCancellable] = []
    
    
    // MARK: Life cycle
    init(imageSelected: UIImage,
         appModule: AppModule) {
        self.imageSelected = imageSelected
        self.appModule = appModule
    }
    
    
    func onAppear() {
        Task {
            if await ownerUseCase.currentUserID == nil {
                self.alertType = .initializingFailed(message: "Invalid User ID. Please signin again")
            }
        }.store(in: &cancellableList)
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }
    
    // MARK: UI events
    func postPicture() {
        Task {
            if await ownerUseCase.currentUserID == nil {
                self.alertType = .postFailed(message: "Invalid User Info. Please restart app.")
                return
            }
            do {
                try await uploadPostUseCase.uploadPost(image: imageSelected, caption: captionText)
                self.alertType = .postFinished
            } catch {
                self.alertType = .postFailed(message: "Failed to upload (\(error.localizedDescription)")
            }
        }.store(in: &cancellableList)
    }
}

