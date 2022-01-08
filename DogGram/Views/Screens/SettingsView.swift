//
//  SettingsView.swift
//  DogGram
//
//  Created by nao on 2021/11/29.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var showSignOutError: Bool = false
    @State var showDeletingAccountError: Bool = false
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                // MARK: Section1: DogGram
                GroupBox(label: SettingsLabelView(
                    labelText: "DogGram",
                    labelImage: "dot.radiowaves.left.and.right"
                )) {
                    HStack(
                        alignment: .center,
                        spacing: 10
                    ) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                        Text("DogGram is the #1 app for pictures of your dog and sharing them across the world. We are a dog-loving community and we're happy to have you!")
                            .font(.footnote)
                    }
                }.padding()
                
                // MARK: Section2 profile
                GroupBox(
                    label: SettingsLabelView(
                        labelText: "Profile",
                        labelImage: "person.fill"
                    )
                ) {
                    NavigationLink(
                        destination: SettingsEditTextView(
                            submissionText: userDisplayName,
                            title: "Display Name",
                            description: "You can edit your display name here. This will be seen by other users on your profile and on your posts!",
                            placeholder: "Your display name here...",
                            settingsEditTextOption: .displayName,
                            profileText: $userDisplayName
                        )
                    ) {
                        SettingsRowView(
                            leftIcon: "pencil",
                            text: "Display Name",
                            color: Color.MyTheme.purpleColor
                        )
                    }
                    
                    NavigationLink(
                        destination: SettingsEditTextView(
                            submissionText: userBio,
                            title: "Profile Bio",
                            description: "Your bio is a great place to let other users know a little about you. It will be shown on your profile only.",
                            placeholder: "Your bio here...",
                            settingsEditTextOption: .bio,
                            profileText: $userBio
                            
                        )
                    ) {
                        SettingsRowView(
                            leftIcon: "text.quote",
                            text: "Bio",
                            color: Color.MyTheme.purpleColor
                        )
                    }
                    
                    NavigationLink(
                        destination: SettingsEditImageView(
                            title: "Profile Picture",
                            description: "Your profile picture will bes hown on your profile and on your posts. MOst users make it an image of themselves or of their dog!",
                            selectedImage: userProfilePicture,
                            profileImage: $userProfilePicture
                        )
                    ) {
                        SettingsRowView(
                            leftIcon: "photo",
                            text: "Profile Picture",
                            color: Color.MyTheme.purpleColor
                        )
                    }
                    NavigationLink(
                        destination: SettingsFeedbackView()
                    ) {
                        SettingsRowView(
                            leftIcon: "envelope",
                            text: "Feedback",
                            color: Color.MyTheme.purpleColor
                        )
                    }

                    if currentUserID != nil {
                        Button {
                            signOut()
                        } label: {
                            SettingsRowView(
                                leftIcon: "figure.walk",
                                text: "Sign Out",
                                color: Color.MyTheme.purpleColor
                            )
                        }.alert (isPresented: $showSignOutError) {
                            Alert(
                                title: Text("Error signing out")
                            )
                        }

                        Button {
                            deleteAccount()
                        } label: {
                            SettingsRowView(
                                leftIcon: "person.fill.xmark",
                                text: "Delete account",
                                color: Color.MyTheme.purpleColor
                            )
                        }.alert (isPresented: $showDeletingAccountError) {
                            Alert(
                                title: Text("Error deleting account")
                            )
                        }
                    }
                }
                .padding()
                
                // MARK: SEction3 APPLICATION
                GroupBox(
                    label: SettingsLabelView(
                        labelText: "Application",
                        labelImage: "apps.iphone"
                    )
                ) {
                    Button {
                        openCustomURL(urlString: "https://www.google.com/")
                    } label: {
                        SettingsRowView(
                            leftIcon: "folder.fill",
                            text: "Privacy Policy",
                            color: Color.MyTheme.yellowColor
                        )
                    }
                    Button {
                        openCustomURL(urlString: "https://www.yahoo.com/")
                    } label: {
                        SettingsRowView(
                            leftIcon: "folder.fill",
                            text: "Terms & Condisions",
                            color: Color.MyTheme.yellowColor
                        )
                    }
                    Button {
                        openCustomURL(urlString: "https://www.bing.com/")
                    } label: {
                        SettingsRowView(
                            leftIcon: "globe",
                            text: "DogDram's Website",
                            color: Color.MyTheme.yellowColor
                        )
                    }
                }
                .padding()
                
                
                // MARK: Section4 Sign off
                GroupBox {
                    Text("DogGram was made with love.\n All Rights Reserved \n Cool Apps Inc. \n Copyright 2021 ❤️")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom, 40)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .accentColor(.primary)
                    }
                )
            )
        }
        .accentColor(colorScheme == .light
                     ? Color.MyTheme.purpleColor
                     : Color.MyTheme.yellowColor)
    }
    
    // MARK: functions
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func signOut() {
        AuthService.instance.logOutUser {(success) in
            if success {
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let dict = UserDefaults.standard.dictionaryRepresentation()
                    dict.keys.forEach {
                        UserDefaults.standard.removeObject(forKey: $0)
                    }
                }
            } else {
                self.showSignOutError = true
            }
        }
    }
    func deleteAccount() {
        guard let currentUserID = currentUserID else {
            return
        }
        /// Remvoe all posts
        /// It's hard to determine what to do when error happens.
        /// This should be processed in server-transaction
        DataService.instance.deleteAllPosts(fromUserID: currentUserID) { postIDs in
            guard let postIDs = postIDs else {
                showDeletingAccountError = true
                return
            }
            // Remove all images, ignore error
            for postID in postIDs {
                ImageManager.instance.deletePostImage(postID: postID) { _ in
                    //ignore error
                }
            }
            // Delete Profile Image
            ImageManager.instance.deleteProfileImage(userID: currentUserID) { _ in
                // ignore error
            }
            // Remove Account from firebase
            AuthService.instance.deleteUser(userID: currentUserID) {(success) in
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let dict = UserDefaults.standard.dictionaryRepresentation()
                        dict.keys.forEach {
                            UserDefaults.standard.removeObject(forKey: $0)
                        }
                    }
                } else {
                    self.showDeletingAccountError = true
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var userDisplayName: String = "NAME"
    @State static var userBio: String = "Bio"
    @State static var userProfileImage: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        SettingsView(
            userDisplayName: $userDisplayName,
            userBio: $userBio,
            userProfilePicture: $userProfileImage
        )
            .preferredColorScheme(.dark)
    }
}