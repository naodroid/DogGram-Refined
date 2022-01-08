//
//  ImageGridView.swift
//  DogGram
//
//  Created by nao on 2021/11/21.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var posts: PostArrayObject
    
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
            ],
            alignment: .center,
            spacing: nil,
            pinnedViews: [])
        {
            ForEach(posts.dataArray, id: \.self) { post in
                NavigationLink(
                    destination: FeedView(
                        posts: PostArrayObject(post: post),
                        title: "\(post.postID)"
                    ),
                    label: {
                        PostView(
                            post: post,
                            addHeartAnimationToView: false,
                            showHeaderAndFooter: false,
                            onPostDeleted: onPostDeleted
                        )
                    }
                )
            }
        }
    }
    private func onPostDeleted(_ postID: String) {
        posts.deletePost(for: postID)
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject())
            .previewLayout(.sizeThatFits)
    }
}
