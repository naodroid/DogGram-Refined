//
//  MessageView.swift
//  DogGram
//
//  Created by nao on 2021/11/19.
//

import SwiftUI

struct MessageView: View {
    let postID: String
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    @State var showOnBoarding = false
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    @State var showDeletingConfirmAlert = false
    
    let onDeleted: ((_ postID: String) -> ())?
    
    var body: some View {
        HStack {
            NavigationLink {
                LazyView {
                    ProfileView(isMyProfile: false,
                                profileDisplayName: comment.username,
                                profileUserID: comment.userID,
                                posts: PostArrayObject(userID: comment.username)
                    )
                }
            } label: {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: nil) {
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(comment.content)
                    .foregroundColor(.primary)
                    .padding(.all, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
                
                HStack {
                    Button {
                        if comment.likedByUser {
                            unlikeComment()
                        } else {
                            likeComment()
                        }
                    } label: {
                        Image(systemName: comment.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(comment.likedByUser ? Color.red : Color.black)
                    }
                    if currentUserID == comment.userID {
                        Button {
                            showDeletingConfirmAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.title3)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .alert(isPresented: $showDeletingConfirmAlert) {
            Alert(
                title: Text("Confirm"),
                message: Text("Delete this comment? this action cannot be undone"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteComment()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            getProfileImage()
        }
        .loggedInGuard(showOnBoarding: $showOnBoarding)
        
    }
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { image in
            if let image = image {
                self.profilePicture = image
            }
        }
    }
    func likeComment() {
        guard let currentUserID = currentUserID else {
            showOnBoarding = true
            return
        }

        // Update the local data
        let updatedComment = CommentModel(id: comment.id,
                                          commentID: comment.commentID,
                                          userID: comment.username,
                                          username: comment.username,
                                          content: comment.content,
                                          dateCreated: comment.dateCreated,
                                          likeCount: comment.likeCount + 1,
                                          likedByUser: true)
        comment = updatedComment
        
        DataService.instance.likeComment(postID: postID,
                                         commentID: comment.commentID,
                                         currentUserID: currentUserID)
    }
    func unlikeComment() {
        guard let currentUserID = currentUserID else {
            showOnBoarding = true
            return
        }
        //
        let updatedComment = CommentModel(id: comment.id,
                                          commentID: comment.commentID,
                                          userID: comment.username,
                                          username: comment.username,
                                          content: comment.content,
                                          dateCreated: comment.dateCreated,
                                          likeCount: comment.likeCount - 1,
                                          likedByUser: false)
        comment = updatedComment

        // Update the database
        DataService.instance.unlikeComment(postID: postID,
                                         commentID: comment.commentID,
                                         currentUserID: currentUserID)
    }
    func deleteComment() {
        guard let currentUserID = currentUserID,
              comment.userID == currentUserID
        else {
            return
        }
        DataService.instance.deleteComment(postID: postID,
                                         commentID: comment.commentID)
        onDeleted?(comment.commentID)
    }
}

struct MessageView_Previews: PreviewProvider {
    static let comment = CommentModel(
        commentID: "",
        userID: "",
        username: "Jeo Green",
        content: "This photo is really cool. haha",
        dateCreated: Date.now,
        likeCount: 1,
        likedByUser: true
    )
    static var previews: some View {
        MessageView(
            postID: "",
            comment: comment,
            onDeleted: nil)
            .previewLayout(.sizeThatFits)
    }
}
