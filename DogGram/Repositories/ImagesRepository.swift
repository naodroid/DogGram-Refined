//
//  ImagesRepository.swift
//  DogGram
//
//  Created by nao on 2022/01/09.
//

import Foundation
import FirebaseStorage
import UIKit


actor ImagesRepository {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    private var storage = Storage.storage()
    
    nonisolated init() {
    }
    
    
    // MARK: Profile images
    
    /// Upload the image as the user's profile image
    func uploadProfileImage(
        userID: String,
        image: UIImage
    ) async throws {
        let path = getProfileImagePath(userID: userID)
        try await uploadImage(path: path, image: image)
    }
    /// Download the user's profile image
    func downloadProfileImage(userID: String) async throws -> UIImage {
        let path = getProfileImagePath(userID: userID)
        return try await downloadImage(path: path)
    }
    func deleteProfileImage(userID: String) async throws {
        let path = getProfileImagePath(userID: userID)
        try await deleteImage(path: path)
    }
    
    // MARK: Posted images
    /// Upload the image for post
    func uploadPostImage(postID: String,
                         image: UIImage
    ) async throws {
        // Get the path where we will save the image
        let path = getPostImagePath(postID: postID)
        // Save image to path
        try await uploadImage(path: path, image: image)
    }
    /// Download the image of the post
    /// When failed, an error will be thrown
    func downloadPostImage(postID: String) async throws -> UIImage {
        let path = getPostImagePath(postID: postID)
        return try await downloadImage(path: path)
    }
    /// Delete the image of the post
    func deletePostImage(postID: String) async throws {
        let path = getPostImagePath(postID: postID)
        try await deleteImage(path: path)
    }

    // MARK: path
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = storage.reference(withPath: userPath)
        return storagePath
    }
    private func getPostImagePath(postID: String) -> StorageReference {
        let postPath = "posts/\(postID)/1"
        let storagePath = storage.reference(withPath: postPath)
        return storagePath
    }
    
    // MARK Common
    /// upload the image
    /// - Parameters:
    ///    - path: the path used to store image
    ///    - image: saved image
    /// - Throws: When failed to upload
    private func uploadImage(path: StorageReference,
                             image: UIImage,
                             size: CGSize = CGSize(width: 640, height: 640)
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let resized = image.resize(size: size) ?? image
            guard let jpegData = resized.jpegData(compressionQuality: 0.9) else {
                continuation.resume(throwing: NSError())
                return
            }
            //
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            path.putData(jpegData,
                         metadata: metadata) { metadata, error in
                if let error =  error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }.resume()
        }
    }
    /// Download the image
    /// - Parameter path: Path of the image
    /// - Returns: downloaded image
    /// - Throws: when failed to download
    private func downloadImage(path: StorageReference) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            if let cached = imageCache.object(forKey: path) {
                continuation.resume(returning: cached)
                return
            }
            path.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let data = data, let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                    self.imageCache.setObject(image, forKey: path)
                } else {
                    let e = error ?? NSError()
                    continuation.resume(throwing: e)
                }
            }
        }
    }
    /// Delete the image that is stored in the path
    private func deleteImage(path: StorageReference) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            path.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
