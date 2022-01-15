//
//  FeedView.swift
//  DogGram
//
//  Created by nao on 2021/11/18.
//

import SwiftUI

struct FeedView: View {
    let title: String
    let posts: [Post]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                ForEach(posts, id: \.self) { (post) in
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
            FeedView(title: "Feed Test", posts: [])
        }
    }
}
