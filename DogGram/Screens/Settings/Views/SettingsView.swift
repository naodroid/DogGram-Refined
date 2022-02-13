//
//  SettingsView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/29.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: SettingsViewModel
    
    //TODO: Remove these
    @State private var userDisplayName = ""
    @State private var userBio = ""
    @State private var userProfilePicture = UIImage(named: "logo.loading")!
    @State private var showSignOutError = false
    @State private var showDeletingAccountError = false

    
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
                            textOption: .displayName
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
                            textOption: .bio
                        )
                    ) {
                        SettingsRowView(
                            leftIcon: "text.quote",
                            text: "Bio",
                            color: Color.MyTheme.purpleColor
                        )
                    }
                    
                    NavigationLink(
                        destination: SettingsEditImageScreen(
                            title: "Profile Picture",
                            description: "Your profile picture will bes hown on your profile and on your posts. MOst users make it an image of themselves or of their dog!"
                        )
                    ) {
                        SettingsRowView(
                            leftIcon: "photo",
                            text: "Profile Picture",
                            color: Color.MyTheme.purpleColor
                        )
                    }
                    NavigationLink(
                        destination: SettingsFeedbackScreen()
                    ) {
                        SettingsRowView(
                            leftIcon: "envelope",
                            text: "Feedback",
                            color: Color.MyTheme.purpleColor
                        )
                    }

                    if viewModel.user != nil {
                        Button {
                            viewModel.signOut()
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
                            viewModel.deleteAccount()
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
}

struct SettingsView_Previews: PreviewProvider {
    @State static var userDisplayName: String = "NAME"
    @State static var userBio: String = "Bio"
    @State static var userProfileImage: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel(appModule: AppModule()))
            .preferredColorScheme(.dark)
    }
}
