//
//  CarouselView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/21.
//

import SwiftUI

struct CarouselView: View {
    @EnvironmentObject var viewModel: BrowseViewModel
    
    var body: some View {
        if viewModel.postsForCarousel.isEmpty {
            emptyView
        } else {
            tabView
        }
    }
    private var emptyView: some View {
        Text("Loading")
    }
    private var tabView: some View {
        TabView(selection: $viewModel.carouselPosition) {
            ForEach(viewModel.postsForCarousel, id: \.id) { post in
                CarouselImage(
                    post: post,
                    image: viewModel.image(for: post)
                )
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default)
    }
}
struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
private struct CarouselImage: View {
    let post: Post
    let image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .id(post.id ?? "")
            .animation(nil)
    }
}

