//
//  ProfileView.swift
//  DogGram
//
//  Created by nao on 2021/11/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var isMyProfile: Bool
    @State var profileDisplayName: String
    var profileUserID: String
    @State var profileBio: String = ""

    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSettings: Bool = false
        
    var body: some View {
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            ProfileHeaderView(
                profileDisplayName: $profileDisplayName,
                profileImage: $profileImage,
                postArray: PostArrayObject(userID: profileUserID),
                profileBio: $profileBio
            )
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(action: {
                showSettings = true
            }, label: {
                Image(systemName: "line.horizontal.3")
            })
                .accentColor(colorScheme == .light
                             ? Color.MyTheme.purpleColor
                             : Color.MyTheme.yellowColor)
                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .onAppear {
            getProfileImage()
            getAdditionalProfileInfo()
        }
        .sheet(isPresented: $showSettings) {
            
        } content: {
            SettingsView(
                userDisplayName: $profileDisplayName,
                userBio: $profileBio,
                userProfilePicture: $profileImage
            )
                .preferredColorScheme(colorScheme)
        }
    }
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { image in
            if let image = image {
                profileImage = image
            }
        }
    }
    func getAdditionalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserID) { name, bio in
            if let name = name {
                self.profileDisplayName = name
            }
            if let bio = bio {
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true,
                profileDisplayName: "Joe",
                        profileUserID: "",
                        posts: PostArrayObject())
        }.preferredColorScheme(.dark)
    }
}
