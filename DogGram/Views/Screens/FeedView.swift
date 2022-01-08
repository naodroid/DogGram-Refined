//
//  FeedView.swift
//  DogGram
//
//  Created by nao on 2021/11/18.
//

import SwiftUI

struct FeedView: View {
    @StateObject var posts: PostArrayObject
    var title: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                ForEach(posts.dataArray, id: \.self) { (post) in
                    PostView(post: post,
                             addHeartAnimationToView: true,
                             showHeaderAndFooter: true,
                             onPostDeleted: onPostDeleted
                    )
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    private func onPostDeleted(_ postID: String) {
        posts.deletePost(for: postID)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView(posts: PostArrayObject(), title: "Feed Test")
        }
    }
}
