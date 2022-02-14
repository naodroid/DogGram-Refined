//
//  FeedView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/18.
//

import SwiftUI
import DataLayer

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    let title: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                ForEach(viewModel.posts, id: \.self) { (post) in
                    PostScreen(
                        post: post,
                        showHeaderAndFooler: true,
                        addHeartAnimationToView: true
                    )
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        //TODO: Create preview posts
        NavigationView {
            FeedView(title: "Feed Test")
                .environmentObject(FeedViewModel(appModule: AppModule()))
        }
    }
}
