//
//  BrowseViewModel.swift
//  DogGram
//
//  Created by naodroid on 2022/01/22.
//

import Foundation
import SwiftUI
import Combine
import DataLayer
import DomainLayer


@MainActor
final class BrowseViewModel: ObservableObject, AppModuleUsing {
    let appModule: AppModule
    //
    @Published private(set) var postsForCarousel: [Post] = []
    @Published private(set) var postsForGrid: [Post] = []
    @Published var carouselPosition = 0
    //
    private var cancellableList: [AnyCancellable] = []
    private var timer: Timer?
    private var imagesForPosts: [String: UIImage] = [:]

    // MARK: Initializer
    init(appModule: AppModule) {
        self.appModule = appModule
    }

    func onAppear() {
        Task {
            do {
                
                let posts = try await postsUseCase.getPostsForBrowse()
                let carouselNum = min(posts.count / 2, 7)
                if carouselNum > 0 {
                    self.postsForCarousel = Array(posts[0...carouselNum])
                }
                self.postsForGrid = Array(posts[carouselNum...])
                self.fetchCarouselImages()
            } catch {
                //TODO: Error handling
            }
        }.store(in: &cancellableList)
        
        EventDispatcher.stream.sink { event in
            self.on(event: event)
        }.store(in: &cancellableList)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true) {[weak self] _ in
                self?.timerProcess()
        }
    }
    func onDisappear() {
        cancellableList.cancelAll()
        timer?.invalidate()
        timer = nil
    }
    
    
    func image(for post: Post) -> UIImage {
        if let id = post.id,
           !id.isEmpty,
           let cached = imagesForPosts[id] {
            return cached
        }
        return UIImage(named: "logo.loading")!
    }
    


    // MARK: Event Handling
    private func on(event: Event) {
        switch event {
        case .onCurrentUserChanged:
            break
        case .onPostsUpdated(let posts):
            self.postsForCarousel.merge(posts)
            self.postsForGrid.merge(posts)
        }
    }
    private func timerProcess() {
        let count = postsForCarousel.count
        if count <= 0 {
            return
        }
        if carouselPosition == count {
            carouselPosition = 1
        } else {
            carouselPosition += 1
        }
    }
    private func fetchCarouselImages() {
        for p in postsForCarousel {
            guard let id = p.id else {
                continue
            }
            Task {
                do {
                    let image = try await postsUseCase.getImage(for: p)
                    imagesForPosts[id] = image
                    //update views
                    objectWillChange.send()
                } catch {
                }
            }.store(in: &cancellableList)
        }
    }
}

