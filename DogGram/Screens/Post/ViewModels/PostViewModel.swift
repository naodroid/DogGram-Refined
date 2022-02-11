//
//  PostViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/15.
//

import Foundation
import SwiftUI
import Combine

enum PostActionSheetOption {
    case menu
    case reporting
    case deletingConfirm
}


@MainActor
final class PostViewModel: ObservableObject, UseCasesModuleUsing, AppModuleUsing {
    //
    private(set) var currentUserID: String?
    private var imageFetched = false
    let appModule: AppModule

    //general info
    @Published private(set) var post: Post
    @Published private(set)var profileImage: UIImage = UIImage(named: "logo.loading")!
    @Published private(set)var postImage: UIImage = UIImage(named: "logo.loading")!
    
    //animation
    @Published var animateLike: Bool = false
    @Published var animateUnlike: Bool = false
    //action sheeet
    @Published private(set)var showActionSheet: Bool = false
    @Published private(set) var alertTitle: String = ""
    @Published private(set) var alertMessage: String = ""
    //
    @Published private(set)var actionSheetType: PostActionSheetOption?
    @Published var showAlert: Bool = false
    @Published var showOnBoarding: Bool = false
    
    private var cancellable: AnyCancellable?
    
    // computed properties
    var likedByUser: Bool {
        guard let currentUserID = currentUserID else {
            return false
        }
        return post.likedBy.contains(currentUserID)
    }
    lazy var showMenu = Binding<Bool>(
        get: { self.actionSheetType == .menu },
        set: {
            self.actionSheetType = $0 ? .menu : nil
        }
    )
    lazy var showDeleteConfirm = Binding<Bool>(
        get:{ self.actionSheetType == .deletingConfirm },
        set: {
            self.actionSheetType = $0 ? .deletingConfirm : nil
        }
    )
    lazy var showReport = Binding<Bool>(
        get: { self.actionSheetType == .reporting },
        set: {
            self.actionSheetType = $0 ? .reporting : nil
        }
    )
    
    
    // MARK: Initializer
    init(post: Post, appModule: AppModule) {
        self.post = post
        self.appModule = appModule
        
    }
    
    func onAppear() {
        Task {
            currentUserID = await ownerUseCase.currentUserID
            if !imageFetched {
                do {
                    guard let postID = post.id else {
                        return
                    }
                    postImage = try await imagesRepository.downloadPostImage(postID: postID)
                    if let uid = currentUserID {
                        profileImage = try await imagesRepository.downloadProfileImage(userID: uid)
                    }
                    imageFetched = true
                } catch {
                }
            }
        }
        self.cancellable = EventDispatcher.stream.sink { event in
            self.on(event: event)
        }
    }
    func onDisappear() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
    
    // MARK: Event Handling
    
    private func on(event: Event) {
        switch event {
        case .onPostsUpdated(let posts):
            onUpdate(posts: posts)
        default:
            break
        }
    }
    private func onUpdate(posts: [Post]) {
        guard let p = posts.first(where: { $0.id == post.id }) else {
            return
        }
        post = p
    }
    
    //
    func deletePost() {
        //TODO
        //        DataService.instance.deletePost(postID: post.postID)
        //        onTapDelete?(post.postID)
    }
    func reportPost(reason: String) {
        //        DataService.instance.uploadReport(reason: reason,
        //                                          postID: post.postID) { success in
        //            showActionSheet = false
        //            if success  {
        //                self.alertTitle = "Reported"
        //                self.alertMessage = "Thanks for reporting the post. We will review it shortly and take the appropriate action!"
        //                self.showAlert = true
        //            } else {
        //                self.alertTitle = "Error"
        //                self.alertMessage = "There was an error uploading ther eport. Please restart the app and try again."
        //                self.showAlert = true
        //            }
        //        }

    }
    func sharePost() {
//        let message = "Check out this post on DogGram!"
//        let image = postImage
//        let link = URL(string: "https://www.google.com")!
//
//        let activityViewController = UIActivityViewController(
//            activityItems: [
//                message, image, link
//            ],
//            applicationActivities: nil
//        )
//        let vc = UIApplication.shared.windows.first?.rootViewController
//        vc?.present(
//            activityViewController,
//            animated: true,
//            completion: nil
//        )
    }

    

    
    // MARK: Like / Unlike
    func toggleLike() {
        if likedByUser {
            unlikePost()
        } else {
            likePost()
        }
    }
    func likePost() {
        Task {
            await _likePost()
        }
    }
    private func _likePost() async {
        guard currentUserID == nil else {
            showOnBoarding = true
            return
        }
        // Update the local data
        do {
            try await postsRepository.like(post: post)
            // Animate UI
            animateLike = true
            await asyncSleep(for: 0.5)
            animateLike = false
        } catch {
            //TODO: Error Alert
        }
    }
    func unlikePost() {
        Task {
            await _unlikePost()
        }
    }
    private func _unlikePost() async {
        guard currentUserID == nil else {
            showOnBoarding = true
            return
        }
        //
        do {
            try await postsRepository.unlike(post: post)
            // Animate UI
            animateUnlike = true
            await asyncSleep(for: 0.5)
            animateUnlike = false
        } catch {
            //TODO: error alert
        }
    }
    
    // MARK: Alert Control
    func showMenuAlert() {
        actionSheetType = .menu
    }
    func showDeleteConfirm(wait: Bool = true) {
        Task {
            if wait {
                actionSheetType = nil
                await asyncSleep(for: 0.5)
            }
            actionSheetType = .deletingConfirm
        }
    }
    func showReportAlert(wait: Bool = true) {
        Task {
            if wait {
                actionSheetType = nil
                await asyncSleep(for: 0.5)
            }
            actionSheetType = .reporting
        }
    }
}

