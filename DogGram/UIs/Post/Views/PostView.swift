//
//  PostView.swift
//  DogGram
//
//  Created by nao on 2021/11/18.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var viewModel: PostViewModel
    let showHeaderAndFooter: Bool
    let addHeartAnimationToView: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // MARK: HEADER
            if showHeaderAndFooter {
                HStack {
                    
                    NavigationLink(destination: LazyView {
                        ProfileScreen(
                            type: .specifiedUser(userID: viewModel.post.userID)
                        )
                    }) {
                        Image(uiImage: viewModel.profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        Text(viewModel.post.displayName)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Button {
                        viewModel.showMenuAlert()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }
                    .accentColor(.primary)
                    .actionSheet(isPresented: viewModel.showMenu) {
                        menuAlert()
                    }
                    .actionSheet(isPresented: viewModel.showDeleteConfirm) {
                        deleteConfirmAlert()
                    }
                    .actionSheet(isPresented: viewModel.showReport) {
                        reportingAlert()
                    }
                }
                .padding(.all, 6)
            }
            // MARK: IMAGE
            ZStack {
                Image(uiImage: viewModel.postImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture(count: 2) {
                        if !viewModel.likedByUser {
                            AnalyticsService.instance.likePostDoubleTap()
                            viewModel.likePost()
                        }
                    }
                if addHeartAnimationToView {
                    LikeAnimationView(animate: $viewModel.animateLike)
                    UnlikeAnimationView(animate: $viewModel.animateUnlike)
                }
            }
            
            // MARK: FOOTER
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        viewModel.toggleLike()
                    } label: {
                        Image(systemName: viewModel.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .accentColor(viewModel.likedByUser ? Color.red : Color.primary)
                    
                    NavigationLink(
                        //TODO: Change comment
                        destination: CommentsView(post:
                                                    PostModel(postID: "",
                                                              userID: "",
                                                              username: "",
                                                              dateCreated: Date(),
                                                              likeCount: 0,
                                                              likedByUser: false
                                                             )
                                                 )
                    ) {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    Button {
                        viewModel.sharePost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                    .accentColor(.primary)
                    Spacer()
                }
                .padding(.all, 6)
                
                if let caption = viewModel.post.caption {
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }
                    .padding(.all, 6)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) { () -> Alert in
            return Alert(title: Text(viewModel.alertTitle),
                         message: Text(viewModel.alertMessage),
                         dismissButton: .default(Text("OK")))
            
        }
        .loggedInGuard(showOnBoarding: $viewModel.showOnBoarding)
    }
    
    //
    private func menuAlert() -> ActionSheet {
        let buttons: [ActionSheet.Button]
        
        if viewModel.post.userID == viewModel.currentUserID {
            buttons = [
                .destructive(Text("Delete")) {
                    viewModel.showDeleteConfirm()
                },
                .default(Text("Learn more ...")) {
                    print("LEARN MORE PRESSED")
                },
                .cancel()
            ]
        } else {
            buttons = [
                .destructive(Text("Report")) {
                    viewModel.showReportAlert()
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
    }
    private func deleteConfirmAlert() -> ActionSheet {
        return ActionSheet(
            title: Text("Confirm"),
            message: Text("Delete this post?"),
            buttons: [
                .destructive(Text("Delete")) {
                    viewModel.deletePost()
                }
            ]
        )
    }
    private func reportingAlert() -> ActionSheet {
        return ActionSheet(
            title: Text("Why are you reporting this post?"),
            message: nil,
            buttons: [
                .destructive(Text("This is inappropriate")) {
                    viewModel.reportPost(reason: "This is inappropriate")
                },
                .destructive(Text("This is spam")) {
                    viewModel.reportPost(reason: "This is spam")
                },
                .destructive(Text("It made me uncomfortable")) {
                    viewModel.reportPost(reason: "It made me uncomfortable")
                },
                .cancel {
                }
            ]
        )
    }
}

// MARK: Preview
struct PostView_Previews: PreviewProvider {
    private static let post = Post(id: nil,
                           postID: "123",
                           userID: "456",
                           displayName: "Name",
                           caption: "Caption",
                           dateCreated: nil,
                           likeCount: 0,
                           likedBy: [],
                           comments: [])
    private static let viewModel = PostViewModel(post: post, appModule: AppModule())
    
    static var previews: some View {
        PostView(showHeaderAndFooter: false,
                 addHeartAnimationToView: false)
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
        PostView(showHeaderAndFooter: true,
                 addHeartAnimationToView: true)
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
    }
}
