//
//  ImagePicker.swift
//  DogGram
//
//  Created by nao on 2021/11/21.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageSelected: UIImage
    @Environment(\.presentationMode) var presentationMode
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(parent: self)
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
            super.init()
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [
                                    UIImagePickerController.InfoKey : Any
                                   ]
        ) {
            if let image = info[.editedImage] as? UIImage
                ?? info[.originalImage] as? UIImage {
                parent.imageSelected = image
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

