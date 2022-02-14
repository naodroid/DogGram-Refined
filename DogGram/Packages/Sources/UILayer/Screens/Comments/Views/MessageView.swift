//
//  MessageView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/19.
//

import SwiftUI
import DataLayer

struct MessageView: View {
    @EnvironmentObject var viewModel: CommentsViewModel
    let comment: Comment
    
    var likedByUser: Bool {
        viewModel.likedByUser(comment: comment)
    }
    
    //FIXME: this view doesn't update after like/unlike
    var body: some View {
        HStack {
            NavigationLink {
                LazyView {
                    ProfileScreen(
                        type: .specifiedUser(userID: comment.userID)
                    )
                }
            } label: {
                Image(uiImage: viewModel.profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: nil) {
                Text(comment.displayName)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(comment.content)
                    .foregroundColor(.primary)
                    .padding(.all, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
                
                HStack {
                    Button {
                        if likedByUser {
                            viewModel.unlike(comment: comment)
                        } else {
                            viewModel.like(comment: comment)
                        }
                    } label: {
                        Image(systemName: likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(likedByUser ? Color.red : Color.black)
                    }
                    if viewModel.isPostedByUser(comment: comment) {
                        Button {
                            viewModel.onDeleteClick()
                        } label: {
                            Image(systemName: "trash")
                                .font(.title3)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .alert(isPresented: $viewModel.showDeletingConfirmAlert) {
            Alert(
                title: Text("Confirm"),
                message: Text("Delete this comment? this action cannot be undone"),
                primaryButton: .destructive(Text("Delete")) {
                    self.viewModel.delete(comment: comment)
                },
                secondaryButton: .cancel()
            )
        }
        .loggedInGuard(showOnBoarding: $viewModel.showOnBoarding)
    }
}

//TODO:
//struct MessageView_Previews: PreviewProvider {
//    static let comment = CommentModel(
//        commentID: "",
//        userID: "",
//        username: "Jeo Green",
//        content: "This photo is really cool. haha",
//        dateCreated: Date.now,
//        likeCount: 1,
//        likedByUser: true
//    )
//    static var previews: some View {
//        MessageView(
//            postID: "",
//            comment: comment,
//            onDeleted: nil)
//            .previewLayout(.sizeThatFits)
//    }
//}
