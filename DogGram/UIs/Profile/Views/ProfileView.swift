//
//  ProfileView.swift
//  DogGram
//
//  Created by nao on 2021/11/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ProfileViewModel
    @State private var showSettings: Bool = false
    
    ///TODO: Remove these states.
    @State var userDisplayName = ""
    @State var userBio = ""
    @State var userProfilePicture = UIImage(named: "logo.loading")!
        
    var body: some View {
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            ProfileHeaderView()
            Divider()
            ImageGridView(posts: viewModel.posts)
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
                .opacity(viewModel.isMyProfile ? 1.0 : 0.0)
        )
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .sheet(isPresented: $showSettings) {
            
        } content: {
            SettingsView(
                userDisplayName: $userDisplayName,
                userBio: $userBio,
                userProfilePicture: $userProfilePicture
            )
                .preferredColorScheme(colorScheme)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static let viewModel = ProfileViewModel(type: .topPage, appModule: AppModule())
    
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(viewModel)
        }.preferredColorScheme(.dark)
    }
}
