//
//  CommentsViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/02/11.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import DataLayer
import DomainLayer

@MainActor
final class CommentsViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    let post: Post
    
    @Published var submissionText: String = ""
    @Published private(set) var comments = [Comment]()
    @Published private(set) var profilePicture: UIImage = UIImage(named: "logo.loading")!
    @Published private(set) var userName: String = ""
    @Published var showOnBoarding = false
    @Published var showDeletingConfirmAlert = false
 
    
    private var user: User?
    private var cancellableList: [AnyCancellable] = []
    

    // MARK: Initializer
    init(appModule: AppModule, post: Post) {
        self.appModule = appModule
        self.post = post
    }

    func onAppear() {
        Task {
            self.user = await ownerUseCase.currentUser
            await getProfileImage()
            await getComments()
        }.store(in: &cancellableList)
        
        EventDispatcher.stream.sink { event in
            self.on(event: event)
        }.store(in: &cancellableList)
    }
    func onDisappear() {
        cancellableList.cancelAll()
    }
    
    func postComment() {
        Task {
            let text = submissionText
            if text.isEmpty { //TODO: inappropriate check
                return
            }
            let comment = try await commentsUseCase.post(content: text, to: post)
            //TOOD: it's better watching repository-data to update comments
            self.comments.append(comment)
        }.store(in: &cancellableList)
    }
    
    // for message view
    func likedByUser(comment: Comment) -> Bool {
        guard let userID = self.user?.id else {
            return false
        }
        return comment.likedBy.contains(userID)
    }
    func isPostedByUser(comment: Comment) -> Bool {
        guard let userID = self.user?.id else {
            return false
        }
        return comment.userID == userID
    }
    
    func onDeleteClick() {
        showDeletingConfirmAlert = true
    }
    func delete(comment: Comment) {
        Task {
            do {
                try await commentsUseCase.delete(comment: comment,
                                                 in: self.post)
            } catch {
                //TODO: error handling
            }
        }.store(in: &cancellableList)
    }
    
    func like(comment: Comment) {
        if self.user?.id == nil {
            showOnBoarding = true
            return
        }
        Task {
            do {
                try await commentsUseCase.like(comment: comment, in: post)
            } catch {
                //TODO: error handling
            }
        }.store(in: &cancellableList)
    }
    func unlike(comment: Comment) {
        if self.user?.id == nil {
            showOnBoarding = true
            return
        }
        Task {
            do {
                try await commentsUseCase.unlike(comment: comment, in: post)
            } catch {
                //TODO: error handling
            }
        }.store(in: &cancellableList)
    }




    // MARK: Event Handling
    private func on(event: Event) {
        switch event {
        case .onCurrentUserChanged(let user):
            Task {
                self.user = user
                await getProfileImage()
            }
            break
        case .onPostsUpdated:
            //TODO: refresh comments
            break
        }
    }
    
    private func getComments() async {
        do {
            self.comments = try await commentsUseCase.getComments(for: post)
        } catch {
            //TODO: error handling
            
        }
    }
    private func getProfileImage() async {
        do {
            guard let userID = self.user?.id else {
                return
            }
            self.profilePicture = try await usersUseCase.getProfileImage(for: userID)
        } catch {
        }
    }
}
