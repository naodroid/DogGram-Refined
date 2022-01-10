//
//  SettingsEditTextView.swift
//  DogGram
//
//  Created by nao on 2021/11/30.
//

import SwiftUI

struct SettingsEditImageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var profileImage: UIImage
    @State var showSuccessAlert: Bool = false
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 200,
                    height: 200,
                    alignment: .center
                )
                .clipped()
                .cornerRadius(12)
            
            Button {
                sourceType = .photoLibrary
                showImagePicker = true
            } label: {
                Text("Import".uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $showImagePicker) {
                
            } content: {
                ImagePicker(
                    imageSelected: $selectedImage,
                    sourceType: $sourceType
                )
            }
            
            
            Button {
                saveImage()
            } label: {
                Text("Save".uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.yellowColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(title)
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            Alert(title: Text("Saved!"),
                  message: nil,
                  dismissButton: .default(
                    Text("OK"),
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                  )
            )
        }
    }
    
    // MARK: Functions
    private func saveImage() {
        guard let currentUserID = currentUserID else {
            return
        }
        profileImage = selectedImage
        ImageManager.instance.uploadProfileImage(userID: currentUserID,
                                                image: selectedImage) { success in
            if success {
                showSuccessAlert = true
            }
        }
        
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    @State static var profileImage: UIImage = UIImage(named: "dog1")!
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(
                title: "Edit Display Name",
                description: "Description",
                selectedImage: UIImage(named: "dog1")!,
                profileImage: $profileImage
            )
        }
    }
}

