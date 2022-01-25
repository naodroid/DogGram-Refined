//
//  ProfileView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ProfileViewModel
    @State private var showSettings: Bool = false
    
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
            SettingsScreen()
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
