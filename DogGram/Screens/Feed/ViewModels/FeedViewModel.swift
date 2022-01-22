//
//  FeedViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/18.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FeedViewModel: ObservableObject, AppModuleUsing {
    @Published private(set) var posts: [Post] = []
    let appModule: AppModule
    private var cancellable: AnyCancellable?

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
        Task {
            do {
                print("FETCH")
                self.posts = try await self.postsRepository.getPostsForFeed()
                print("FETCHED:\(self.posts.count)")
            } catch {
                //TODO: Error handling
                print("ERROR")
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
        for p1 in posts {
            for (index, p2) in self.posts.enumerated() {
                if p2.id == p1.id {
                    self.posts[index] = p1
                    break
                }
            }
        }
    }
}
