//
//  UploadPostUseCase.swift
//  DogGram
//
//  Created by naodroid on 2022/02/10.
//

import Foundation
import UIKit
import DataLayer


public protocol UploadPostUseCase {
    @discardableResult
    func uploadPost(image: UIImage,
                    caption: String?) async throws -> Post
}


public class UploadPostUseCaseImpl: UploadPostUseCase, RepositoryModuleUsing {
    public let repositoriesModule: RepositoriesModule
    
    /// initializer
    public init(repositoriesModule: RepositoriesModule) {
        self.repositoriesModule = repositoriesModule
    }
    // MARK: Upload Post
    @discardableResult
    public func uploadPost(image: UIImage,
                    caption: String?) async throws -> Post {
        guard let user = await authRepository.currentUser,
              let userID = user.id else {
            //TODO: create custom error
            throw NSError()
        }
        
        var createdPostID: String?
        do {
            let post = try await postsRepository.createPost(
                caption: caption,
                displayName: user.displayName,
                userID: userID)
            guard let postID = post.id else {
                //TOOD: create custom error
                throw NSError()
            }
            
            createdPostID = post.id
            try await imagesRepository.uploadPostImage(postID: postID, image: image)
            return post
        } catch {
            if let id = createdPostID {
                try? await postsRepository.deletePost(id: id)
            }
            throw error
        }
    }

}
