//
//  UploadViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/10.
//

import Foundation
import SwiftUI
import Combine


@MainActor
final class UploadViewModel: ObservableObject, AppModuleUsing {
    @Published var currentUserID: String?
    @Published var imageSelected: UIImage = UIImage(named: "logo")!
    @Published var sourceType: UIImagePickerController.SourceType?
    @Published var showPostImageView = false
    @Published var showOnBoarding = false

    
    lazy var showImagePicker = Binding<Bool>(
        get: { self.sourceType != nil },
        set: { (newValue) in
            if !newValue {
                self.sourceType = nil
            }
        }
    )
    
    let appModule: AppModule
    private var cancellableList: [AnyCancellable] = []
    
    //MARK: Life cycle
    init(appModule: AppModule) {
        self.appModule = appModule
    }
    func onAppear() {
        Task {
            currentUserID = await authRepository.currentUserID
        }.store(in: &cancellableList)
        
        EventDispatcher.stream.sink {[weak self] event in
            self?.on(event: event)
        }.store(in: &cancellableList)
        
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }
    private func on(event: Event) {
        switch event {
        case .onCurrentUserChanged(let user):
            currentUserID = user?.id
        case .onPostsUpdated:
            break
        }
    }
    
    // MARK: UI action
    func onCameraClick() {
        if currentUserID != nil {
            sourceType = .camera
        } else {
            showOnBoarding = true
        }
    }
    func onImportClick() {
        if currentUserID != nil {
            sourceType = .photoLibrary
        } else {
            showOnBoarding = true
        }
    }
    func onImageSelected() {
        Task {
            await asyncSleep(for: 0.5)
            showPostImageView = true
        }.store(in: &cancellableList)
    }
}

