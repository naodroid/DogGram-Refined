//
//  CommentsView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/19.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: CommentsViewModel
    
    
    var body: some View {
        VStack {
            // Messages ScrollView
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments, id: \.self) { comment in
                        MessageView(
                            comment: comment
                        )
                    }
                }
            }
            
            // Botom HStack
            HStack {
                Image(uiImage: viewModel.profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                TextField("Add a comment here...",
                          text: $viewModel.submissionText)
                Button(action: {
                    viewModel.postComment()
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                })
                    .accentColor(
                        colorScheme == .light
                        ? Color.MyTheme.purpleColor
                        : Color.MyTheme.yellowColor
                    )
            }
            .padding(.all, 6)
        }
        .padding(.horizontal)
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .loggedInGuard(showOnBoarding: $viewModel.showOnBoarding)
    }
}

//TODO: this doesn't work well
//struct CommentsView_Previews: PreviewProvider {
//    static let post = Post(postID: "ID",
//                           userID: "userID",
//                           username: "userName",
//                           dateCreated: Date(),
//                           likeCount: 0,
//                           likedByUser: false)
//    static var previews: some View {
//        NavigationView {
//            CommentsView()
//                .environmentObject(CommentsViewModel(appModule: AppModule, post: post))
//        }
//        .preferredColorScheme(.dark)
//    }
//}
