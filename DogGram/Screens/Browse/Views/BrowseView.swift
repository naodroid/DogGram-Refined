//
//  BrowseView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/21.
//

import SwiftUI

@MainActor
struct BrowseView: View {
    @EnvironmentObject var viewModel: BrowseViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            CarouselView()
            ImageGridView(posts: viewModel.postsForGrid)
        }
        .navigationTitle("Browse")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView()
                .environmentObject(BrowseViewModel(appModule: AppModule()))
        }
    }
}
