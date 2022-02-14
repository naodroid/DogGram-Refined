//
//  SettingsEditImageViewModel.swift
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
final class SettingsEditImageViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    let title: String
    let description: String

    //
    @Published var submissionText: String = ""
    @Published var selectedImage: UIImage = UIImage(named: "logo.loading")!
    @Published var showImagePicker: Bool = false
    @Published private(set) var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showSuccessAlert: Bool = false
    //
    private var cancellableList: [AnyCancellable] = []
    

    // MARK: Initializer
    init(appModule: AppModule, title: String, description: String) {
        self.appModule = appModule
        self.title = title
        self.description = description
    }

    func onAppear() {
    }
    func onDisappear() {
    }
    
    func onImportClick() {
        sourceType = .photoLibrary
        showImagePicker = true
    }
    func saveImage() {
        Task {
            do {
                try await ownerUseCase.updateProfileImage(selectedImage)
                self.showSuccessAlert = true
            } catch {
                //TODO: Error handling
            }
            
        }.store(in: &cancellableList)
    }
}
