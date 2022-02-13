//
//  ImageGridView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/21.
//

import SwiftUI

struct ImageGridView: View {
    let posts: [Post]
    
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
            ForEach(posts, id: \.self) { post in
                NavigationLink(
                    destination: FeedView(
                        //TODO: set title
                        title: "\(post.id)"
                    ),
                    label: {
                        PostScreen(
                            post: post,
                            showHeaderAndFooler: false,
                            addHeartAnimationToView: false
                        )
                    }
                )
            }
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        //TODO: Create preview posts
        ImageGridView(posts: [])
            .previewLayout(.sizeThatFits)
    }
}
