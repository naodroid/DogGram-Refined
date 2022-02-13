//
//  ContentView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            NavigationView {
                FeedScreen(
                    title: "Feed View"
                )
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Feed")
            }
            NavigationView {
                BrowseScreen()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Browse")
            }
            
            UploadScreen()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }
            ZStack {
                if viewModel.userLoggedIn {
                    NavigationView {
                        ProfileScreen(type: .topPage)
                    }
                } else {
                    SignUpView()
                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(
            colorScheme == .light
            ? Color.MyTheme.purpleColor
            : Color.MyTheme.yellowColor
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
