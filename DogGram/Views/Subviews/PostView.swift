//
//  PostView.swift
//  DogGram
//
//  Created by nao on 2021/11/18.
//

import SwiftUI

struct PostView: View {
    @State var post: PostModel
    @State var animateLike: Bool = false
    @State var animateUnlike: Bool = false
    @State var addHeartAnimationToView: Bool
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    var showHeaderAndFooter: Bool
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State var showOnBoarding: Bool = false
    
    let onPostDeleted: ((_ postID: String) -> ())?
    
    enum PostActionSheetOption {
        case general
        case reporting
        case deletingConfirm
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // MARK: HEADER
            if showHeaderAndFooter {
                HStack {
                    
                    NavigationLink(destination: LazyView {
                        ProfileView(
                            isMyProfile: false,
                            profileDisplayName: post.username,
                            profileUserID: post.userID,
                            posts: PostArrayObject(userID: post.userID)
                        )
                    }) {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Button {
                        showActionSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }
                    .accentColor(.primary)
                    .actionSheet(isPresented: $showActionSheet) {
                        getActionSheet()
                    }
                }
                .padding(.all, 6)
            }
            // MARK: IMAGE
            ZStack {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture(count: 2) {
                        if !post.likedByUser {
                            AnalyticsService.instance.likePostDoubleTap()
                            likePost()
                        }
                    }
                if addHeartAnimationToView {
                    LikeAnimationView(animate: $animateLike)
                    UnlikeAnimationView(animate: $animateUnlike)
                }
            }
            
            // MARK: FOOTER
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        if post.likedByUser {
                            unlikePost()
                        } else {
                            likePost()
                            AnalyticsService.instance.likePostHeartPressed()
                        }
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .accentColor(post.likedByUser ? Color.red : Color.primary)
                    
                    NavigationLink(
                        destination: CommentsView(post: post)
                    ) {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    Button {
                        sharePost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                    .accentColor(.primary)
                    Spacer()
                }
                .padding(.all, 6)
                
                if let caption = post.caption {
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }
                    .padding(.all, 6)
                }
            }
        }
        .onAppear {
            getImages()
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            return Alert(title: Text(alertTitle),
                         message: Text(alertMessage),
                         dismissButton: .default(Text("OK")))
            
        }
        .loggedInGuard(showOnBoarding: $showOnBoarding)
    }
    
    // MARK: Functions
    
    func likePost() {
        guard let currentUserID = currentUserID else {
            showOnBoarding = true
            return
        }

        // Update the local data
        let updatedPost = PostModel(id: post.id,
                                    postID: post.postID,
                                    userID: post.userID,
                                    username: post.username,
                                    caption: post.caption,
                                    dateCreated: post.dateCreated,
                                    likeCount: post.likeCount + 1,
                                    likedByUser: true)
        post = updatedPost
        
        // Animate UI
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animateLike = false
        }
        
        // Update the database
        DataService.instance.likePost(postID: post.postID,
                                      currentUserID: currentUserID)
    }
    func unlikePost() {
        guard let currentUserID = currentUserID else {
            showOnBoarding = true
            return
        }
        //
        let updatedPost = PostModel(id: post.id,
                                    postID: post.postID,
                                    userID: post.userID,
                                    username: post.username,
                                    caption: post.caption,
                                    dateCreated: post.dateCreated,
                                    likeCount: post.likeCount - 1,
                                    likedByUser: false)
        post = updatedPost
        
        animateUnlike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animateUnlike = false
        }

        // Update the database
        DataService.instance.unlikePost(postID: post.postID,
                                        currentUserID: currentUserID)
    }
    
    func getImages() {
        ImageManager.instance.downloadProfileImage(userID: post.userID) { image in
            if let image = image {
                self.profileImage = image
            }
        }
        ImageManager.instance.downloadPostImage(postID: post.postID) { image in
            if let image = image {
                self.postImage = image
            }
        }
    }
    
    func getActionSheet() -> ActionSheet {
        switch self.actionSheetType {
        case .general:
            let buttons: [ActionSheet.Button]
            
            if post.userID == currentUserID {
                buttons = [
                    .destructive(Text("Delete")) {
                        actionSheetType = .deletingConfirm
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showActionSheet = true
                        }
                    },
                    .default(Text("Learn more ...")) {
                        print("LEARN MORE PRESSED")
                    },
                    .cancel()
                ]
            } else {
                buttons = [
                    .destructive(Text("Report")) {
                        actionSheetType = .reporting
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showActionSheet = true
                        }
                    },
                    .default(Text("Learn more ...")) {
                        print("LEARN MORE PRESSED")
                    },
                    .cancel()
                ]
            }
            
            return ActionSheet(
                title: Text("What would you like to do?"),
                message: nil,
                buttons: buttons
            )
        case .reporting:
            return ActionSheet(
                title: Text("Why are you reporting this post?"),
                message: nil,
                buttons: [
                    .destructive(Text("This is inappropriate")) {
                        reportPost(reason: "This is inappropriate")
                    },
                    .destructive(Text("This is spam")) {
                        reportPost(reason: "This is spam")
                    },
                    .destructive(Text("It made me uncomfortable")) {
                        reportPost(reason: "It made me uncomfortable")
                    },
                    .cancel {
                        actionSheetType = .general
                    }
                ]
            )
        case .deletingConfirm:
            return ActionSheet(
                title: Text("Confirm"),
                message: Text("Delete this post?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        deletePost()
                    },
                    .cancel {
                        actionSheetType = .general
                    }
                ]
            )
        }
    }
    
    func reportPost(reason: String) {
        
        DataService.instance.uploadReport(reason: reason,
                                          postID: post.postID) { success in
            showActionSheet = false
            if success  {
                self.alertTitle = "Reported"
                self.alertMessage = "Thanks for reporting the post. We will review it shortly and take the appropriate action!"
                self.showAlert = true
            } else {
                self.alertTitle = "Error"
                self.alertMessage = "There was an error uploading ther eport. Please restart the app and try again."
                self.showAlert = true
            }
        }
    }
    
    func sharePost() {
        let message = "Check out this post on DogGram!"
        let image = postImage
        let link = URL(string: "https://www.google.com")!
        
        let activityViewController = UIActivityViewController(
            activityItems: [
                message, image, link
            ],
            applicationActivities: nil
        )
        let vc = UIApplication.shared.windows.first?.rootViewController
        vc?.present(
            activityViewController,
            animated: true,
            completion: nil
        )
    }
    
    private func deletePost() {
        DataService.instance.deletePost(postID: post.postID)
        onPostDeleted?(post.postID)
    }
}

struct PostView_Previews: PreviewProvider {
    static var post = PostModel(
        postID: "postID",
        userID: "userID",
        username: "Jeo Green",
        caption: "This is a test caption",
        dateCreated: Date.now,
        likeCount: 0,
        likedByUser: false
    )
    static var previews: some View {
        PostView(post: post,
                 addHeartAnimationToView: false,
                 showHeaderAndFooter: false,
                 onPostDeleted: nil)
            .previewLayout(.sizeThatFits)
        PostView(post: post,
                 addHeartAnimationToView: true,
                 showHeaderAndFooter: true,
                 onPostDeleted: nil)
            .previewLayout(.sizeThatFits)
    }
}
