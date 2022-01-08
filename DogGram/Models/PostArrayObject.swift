//
//  PostArrayObject.swift
//  DogGram
//
//  Created by nao on 2021/11/19.
//

import Foundation

class PostArrayObject: ObservableObject {
    @Published var dataArray: [PostModel] = [] {
        didSet { updateCounts() }
    }
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    /// The course deleted this initializer because this can be replaced with other methods.
    /// But I suppose this is helpful for previews and I didn't delete this.
    init() {
        let post1 = PostModel(
            postID: "",
            userID: "",
            username: "Jeo Green",
            caption: "This is a test caption",
            dateCreated: Date.now,
            likeCount: 0,
            likedByUser: false
        )
        let post2 = PostModel(
            postID: "",
            userID: "",
            username: "Jessica",
            caption: nil,
            dateCreated: Date.now,
            likeCount: 0,
            likedByUser: false
        )
        let post3 = PostModel(
            postID: "",
            userID: "",
            username: "Emily",
            caption: "This is a really really long capthion hahahaha.",
            dateCreated: Date.now,
            likeCount: 0,
            likedByUser: false
        )
        let post4 = PostModel(
            postID: "",
            userID: "",
            username: "Chirstopher",
            caption: nil,
            dateCreated: Date.now,
            likeCount: 0,
            likedByUser: false
        )
        dataArray.append(post1)
        dataArray.append(post2)
        dataArray.append(post3)
        dataArray.append(post4)
    }
    
    /// USED FOR SINGLE POST SELECTION
    init(post: PostModel) {
        dataArray.append(post)
    }
    
    /// USED FOR GETTING POSTS FOR USER PROFILE
    init(userID: String) {
        DataService.instance.downloadPostForUser(userID: userID) {[weak self] posts in
            let sortedPosts = posts.sorted { (p1, p2) -> Bool in
                return p1.dateCreated > p2.dateCreated
            }
            self?.dataArray.append(contentsOf: sortedPosts)
        }
    }
    
    /// USED FOR FEED
    init(shuffled: Bool) {
        DataService.instance.downloadPostsForFeed { posts in
            if shuffled {
                let shuffledPosts = posts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            } else {
                self.dataArray.append(contentsOf: posts)
            }
        }
    }
    func updateCounts() {
        postCountString = "\(dataArray.count)"
        let likeCountArray = dataArray.map { existingPost in
            return existingPost.likeCount
        }
        let sum = likeCountArray.reduce(0, +)
        likeCountString = "\(sum)"
    }
    func deletePost(for postID: String) {
        dataArray = dataArray.filter { $0.postID != postID }
        
    }
}
