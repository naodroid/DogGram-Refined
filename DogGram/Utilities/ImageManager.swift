//
//  ImageManager.swift
//  DogGram
//
//  Created by naodroid on 2021/12/19.
//

import Foundation
import FirebaseStorage
import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class ImageManager {
    // MARK: properties
    static let instance = ImageManager()
    
    private var REF_STORE = Storage.storage()
    
    // MARK: Profile images
    func uploadProfileImage(userID: String,
                            image: UIImage,
                            handler: @escaping (_ success: Bool) -> ()
    ) {
        // Get the path where we will save the image
        let path = getProfileImagePath(userID: userID)
        
        // Save image to path
        uploadImage(path: path, image: image, handler: handler)
    }
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        let path = getProfileImagePath(userID: userID)
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) {(image) in
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
    }
    func deleteProfileImage(userID: String, handler: @escaping (_ success: Bool?) -> ()) {
        let path = getProfileImagePath(userID: userID)
        deleteImage(path: path, handler: handler)
    }
    
    // MARK: Posted images
    func uploadPostImage(postID: String,
                         image: UIImage,
                         handler: @escaping (_ success: Bool) -> ()
    ) {
        // Get the path where we will save the image
        let path = getPostImagePath(postID: postID)
        // Save image to path
        uploadImage(path: path, image: image, handler: handler)
    }
    func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        let path = getPostImagePath(postID: postID)
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) {(image) in
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
    }
    
    func deletePostImage(postID: String, handler: @escaping (_ success: Bool) -> ()) {
        let path = getPostImagePath(postID: postID)
        deleteImage(path: path, handler: handler)
    }

    // MARK: private functions
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STORE.reference(withPath: userPath)
        return storagePath
    }
    private func getPostImagePath(postID: String) -> StorageReference {
        let postPath = "posts/\(postID)/1"
        let storagePath = REF_STORE.reference(withPath: postPath)
        return storagePath
    }
    
    
    private func uploadImage(path: StorageReference,
                             image: UIImage,
                             handler: @escaping (_ success: Bool) -> ()
    ) {
        var compression: CGFloat = 1.0
        let maxFileSize = 240 * 240
        let maxCompression: CGFloat = 0.05
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from the image")
            handler(false)
            return
        }
        while originalData.count > maxFileSize && compression > maxCompression {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
                break
            }
        }
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            handler(false)
            return
        }
        //
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        path.putData(finalData,
                     metadata: metadata) { metadata, error in
            if let error =  error {
                print("Error uploading image: \(error)")
                handler(false)
            } else {
                handler(true)
            }
        }.resume()
    }
    
    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        if let cached = imageCache.object(forKey: path) {
            handler(cached)
            return
        }
        path.getData(maxSize: 27 * 1024 * 1024) { data, error in
            if let data = data, let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: path)
                handler(image)
            } else {
                print("Downloading Image error : \(error)")
                handler(nil)
            }
        }
    }
    private func deleteImage(path: StorageReference, handler: @escaping (_ sucess: Bool) -> ()) {
        path.delete { error in
            handler(error == nil)
        }
    }
}
