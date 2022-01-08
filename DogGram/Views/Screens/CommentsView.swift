//
//  CommentsView.swift
//  DogGram
//
//  Created by nao on 2021/11/19.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    
    var post: PostModel
    
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @State var showOnBoarding = false

    var body: some View {
        VStack {
            // Messages ScrollView
            ScrollView {
                LazyVStack {
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(
                            postID: post.postID,
                            comment: comment,
                            onDeleted: onCommentDeleted
                        )
                    }
                }
            }
            
            // Botom HStack
            HStack {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                TextField("Add a comment here...",
                          text: $submissionText)
                Button(action: {
                    addComment()
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
        .onAppear {
            getComments()
            getProfilePicture()
        }
        .loggedInGuard(showOnBoarding: $showOnBoarding)
    }
    
    // MARK: Functions
    func getProfilePicture() {
        guard let currentUserID = currentUserID else {
            return
        }

        ImageManager.instance.downloadProfileImage(userID: currentUserID) { image in
            if let image = image {
                self.profilePicture = image
            }
        }
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else {
            return
        }
        
        // FIXME: this caption shouldn't used CommentModel and CommentView
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentID: "",
                                              userID: post.userID,
                                              username: post.username,
                                              content: caption,
                                              dateCreated: post.dateCreated,
                                              likeCount: 0,
                                              likedByUser: false)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { comments in
            self.commentArray.append(contentsOf: comments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innappropriate things
        let badWordArray: [String] = ["shit", "ass"]
        let words = submissionText.components(separatedBy: " ")
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func addComment() {
        guard let currentUserID = currentUserID,
              let displayName = displayName
        else {
            showOnBoarding = true
            return
        }
        guard textIsAppropriate() else {
            return
        }
        DataService.instance.uploadComment(postID: post.postID,
                                           content: submissionText,
                                           displayName: displayName,
                                           userID: currentUserID) { success, commentID in
            if success, let commentID = commentID {
                let newComment = CommentModel(commentID: commentID,
                                              userID: currentUserID,
                                              username: displayName,
                                              content: submissionText,
                                              dateCreated: Date(),
                                              likeCount: 0,
                                              likedByUser: false)
                self.commentArray.append(newComment)
                self.submissionText = ""
                //dismiss keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil,
                                                from: nil,
                                                for: nil)
            }
        }
    }
    private func onCommentDeleted(_ commentID: String) {
        commentArray = commentArray.filter { $0.commentID != commentID }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static let postModel = PostModel(postID: "ID",
                                     userID: "userID",
                                     username: "userName",
                                     dateCreated: Date(),
                                     likeCount: 0,
                                     likedByUser: false)
    static var previews: some View {
        NavigationView {
            CommentsView(post: postModel)
        }
        .preferredColorScheme(.dark)
    }
}
