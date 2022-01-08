//
//  OnBordingViewPart2.swift
//  DogGram
//
//  Created by nao on 2021/12/05.
//

import SwiftUI

struct OnBoardingViewPart2: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            TextField(
                "Add your name here",
                text: $displayName
            )
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .foregroundColor(Color.black)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button {
                showImagePicker = true
            } label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            .opacity(displayName.isEmpty ? 0.2 : 1.0)
            .animation(.easeInOut)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker) {
            createProfile()
        } content: {
            ImagePicker(
                imageSelected: $imageSelected,
                sourceType: $sourceType
            )
        }
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error creating Profile"))
        }
    }
        
    func createProfile() {
        print("CREATE PROFILE")
        AuthService.instance.createNewUserInDatabase(
            name: displayName,
            email: email,
            providerID: providerID,
            provider: provider,
            profileImage: imageSelected
        ) { userId in
            if let userId = userId {
                AuthService.instance.loginUserToApp(userID: userId) { success in
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        self.showError = true
                    }
                }
            } else {
                print("Error craeting user in firebase")
                showError = true
            }
        }
    }
}

struct OnBordingViewPart2_Previews: PreviewProvider {
    
    @State static var displayName: String = ""
    @State static var email: String = ""
    @State static var providerID: String = ""
    @State static var provider: String = ""
    
    
    static var previews: some View {
        OnBoardingViewPart2(
            displayName: $displayName,
            email: $email,
            providerID: $providerID,
            provider: $provider
        ).preferredColorScheme(.dark)
    }
}
