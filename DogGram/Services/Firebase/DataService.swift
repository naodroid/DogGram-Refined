//
//  DataService.swift
//  DogGram
//
//  Created by nao on 2021/12/30.
//

// Used to handle upload and downloading (other than Users) from our database
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    static let instance = DataService()
    
    private var REF_POSTS = DB_BASE.collection("posts")
    private var REF_REPORTS = DB_BASE.collection("reports")
    private var REF_FEEDBACK = DB_BASE.collection("feedback")

    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    
    func uploadPost(image: UIImage,
                    caption: String?,
                    displayName: String,
                    userID: String,
                    handler: @escaping (_ success: Bool) -> ()) {
        // Create new post document
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        // Upload image to storage
        ImageManager.instance.uploadPostImage(postID: postID,
                                              image: image) { (success) in
            if success {
                let postData: [String: Any] = [
                    DatabasePostField.postID : postID,
                    DatabasePostField.userID : userID,
                    DatabasePostField.displayName : displayName,
                    DatabasePostField.caption : caption ?? "",
                    DatabasePostField.dateCreated : FieldValue.serverTimestamp()
                ]
                document.setData(postData) { error in
                    if let error = error {
                        handler(false)
                    } else {
                        handler(true)
                    }
                }
            } else {
                handler(false)
            }
        }
    }
    // TODO: add callback
    func deletePost(postID: String) {
        REF_POSTS.document(postID)
            .delete()
    }
    /// pass all postIDs that has been posted by this userID to the handler.
    /// when error happened, nil will be passed.
    func deleteAllPosts(fromUserID userID: String, handler: @escaping (_ postIDs: [String]?) -> ()) {
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID)
            .getDocuments { snapshot, _ in
                guard let snapshot = snapshot else {
                    handler(nil)
                    return
                }
                // Remove all posts Posted by user
                // to remove all data, remove all subtrees in this post.
                // https://firebase.google.com/docs/firestore/manage-data/delete-data?hl=ja
                var postIDs: [String] = []
                for document in snapshot.documents {
                    guard
                        let postID = document.get(DatabasePostField.postID) as? String
                    else {
                        continue
                    }
                    // Remove all comments
                    // TODO: check has no error
                    self.REF_POSTS.document(postID).collection(DatabasePostField.comments).document().delete()
                    self.REF_POSTS.document(postID).delete()
                    postIDs.append(postID)
                }
                // TODO: Remove All comments posted by user
                // It may be hard in this data structure, because we need to search all posts.
                // TODO: update all feeds
                handler(postIDs)
            }
    }
    
    // MARK: Get Functions
    func downloadPostForUser(userID: String, handler: @escaping (_ posts: [PostModel]) -> ()) {
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID)
            .getDocuments { snapshot, error in
                let postArray = self.getPostsFromSnapshot(querySnapshot: snapshot)
                handler(postArray)
            }
    }
    func downloadPostsForFeed(handler: @escaping (_ posts: [PostModel]) -> ()) {
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true)
            .limit(to: 50)
            .getDocuments { snapshot, error in
                let posts = self.getPostsFromSnapshot(querySnapshot: snapshot)
                handler(posts)
            }
    }
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        guard let snapshot = querySnapshot,
                snapshot.documents.count > 0
        else {
            return []
        }
        for document in snapshot.documents {
            guard
                let postID = document.get(DatabasePostField.postID) as? String,
                let userID = document.get(DatabasePostField.userID) as? String,
                let displayName = document.get(DatabasePostField.displayName) as? String,
                let dateCreated = document.get(DatabasePostField.dateCreated) as? Timestamp
            else {
                continue
            }
            let caption = document.get(DatabasePostField.caption) as? String
            let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0
            
            var likedByUser = false
            if let likedBy = document.get(DatabasePostField.likedBy) as? [String],
               let userID = currentUserID {
                likedByUser = likedBy.contains(userID)
            }
            
            let newPost = PostModel(postID: postID,
                                    userID: userID,
                                    username: displayName,
                                    caption: caption,
                                    dateCreated: dateCreated.dateValue(),
                                    likeCount: likeCount,
                                    likedByUser: likedByUser)
            postArray.append(newPost)
        }
        return postArray
    }
    
    // MARK
    func likePost(postID: String, currentUserID: String) {
        let data: [String: Any] = [
            DatabasePostField.likeCount: FieldValue.increment(Int64(1)),
            DatabasePostField.likedBy: FieldValue.arrayUnion([currentUserID])
        ]
        REF_POSTS.document(postID).updateData(data)
    }
    func unlikePost(postID: String, currentUserID: String) {
        let data: [String: Any] = [
            DatabasePostField.likeCount: FieldValue.increment(Int64(-1)),
            DatabasePostField.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        REF_POSTS.document(postID).updateData(data)
    }
    
    // MARK
    func uploadReport(reason: String, postID: String, handler: @escaping (_ success: Bool) -> ()) {
        let data: [String: Any] = [
            DatabaseReportField.postID: postID,
            DatabaseReportField.content: reason,
            DatabaseReportField.dateCreated: FieldValue.serverTimestamp()
        ]
        REF_REPORTS.addDocument(data: data) { error in
            if let error = error {
                print("REPORT_ERROR: \(error)")
                handler(false)
            } else {
                handler(true)
            }
        }
    }
    
    func uploadComment(postID: String,
                       content: String,
                       displayName: String,
                       userID: String,
                       handler: @escaping (_ success: Bool, _ commentID: String?) -> ()) {
        let document = REF_POSTS.document(postID).collection(DatabasePostField.comments).document()
        let commentID = document.documentID
        let data: [String: Any] = [
            DatabaseCommentField.commentID: commentID,
            DatabaseCommentField.userID: userID,
            DatabaseCommentField.content: content,
            DatabaseCommentField.displayName: displayName,
            DatabaseCommentField.dateCreated: FieldValue.serverTimestamp(),
        ]
        document.setData(data) { (error) in
            if let error = error {
                print("Error uploading comment. \(error)")
                handler(false, nil)
            } else {
                handler(true, commentID)
            }
        }
    }
    func downloadComments(postID: String, handler: @escaping (_ comments: [CommentModel]) -> ()) {
        REF_POSTS.document(postID).collection(DatabasePostField.comments)
            .order(by: DatabasePostField.dateCreated, descending: true)
            .getDocuments { snapshot, error in
                handler(self.getCommentsFromSnapshot(querySnapshot: snapshot))
            }
    }
    private func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        guard let snapshot = querySnapshot,
                snapshot.documents.count > 0
        else {
            return []
        }
        var commentArray = [CommentModel]()
        for document in snapshot.documents {
            guard
                let commentID = document.get(DatabaseCommentField.commentID) as? String,
                let userID = document.get(DatabaseCommentField.userID) as? String,
                let displayName = document.get(DatabaseCommentField.displayName) as? String,
                let dateCreated = document.get(DatabaseCommentField.dateCreated) as? Timestamp,
                let content = document.get(DatabaseCommentField.content) as? String
            else {
                continue
            }
            let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0
            
            var likedByUser = false
            if let likedBy = document.get(DatabasePostField.likedBy) as? [String],
               let userID = currentUserID {
                likedByUser = likedBy.contains(userID)
            }

            let newComment = CommentModel(commentID: commentID,
                                          userID: userID,
                                          username: displayName,
                                          content: content,
                                          dateCreated: dateCreated.dateValue(),
                                          likeCount: likeCount,
                                          likedByUser: likedByUser)
            commentArray.append(newComment)
        }
        return commentArray
    }
    
    func likeComment(postID: String, commentID: String, currentUserID: String) {
        let data: [String: Any] = [
            DatabaseCommentField.likeCount: FieldValue.increment(Int64(1)),
            DatabaseCommentField.likedBy: FieldValue.arrayUnion([currentUserID])
        ]
        let comment = REF_POSTS.document(postID)
            .collection(DatabasePostField.comments)
            .document(commentID)
        comment.updateData(data)
    }
    func unlikeComment(postID: String, commentID: String, currentUserID: String) {
        let data: [String: Any] = [
            DatabaseCommentField.likeCount: FieldValue.increment(Int64(-1)),
            DatabaseCommentField.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        let comment = REF_POSTS.document(postID)
            .collection(DatabasePostField.comments)
            .document(commentID)
        comment.updateData(data)
    }
    // TODO: add callback
    func deleteComment(postID: String, commentID: String) {
        // it's better to check userID
        REF_POSTS.document(postID)
            .collection(DatabasePostField.comments)
            .document(commentID)
            .delete()
    }
    
    
    ///
    func updateDisplayNameOnPosts(userID: String, displayName: String) {
        downloadPostForUser(userID: userID) { posts in
            for post in posts {
                self.updatePostDisplayName(postID: post.postID, displayName: displayName)
            }
        }
    }
    private func updatePostDisplayName(postID: String, displayName: String) {
        let data: [String: Any] = [
            DatabasePostField.displayName: displayName
        ]
        REF_POSTS.document(postID).updateData(data)
    }
    
    //
    func uploadFeedback(email: String?, message: String, handler: @escaping (_ success: Bool) -> ()) {
        let data: [String: Any] = [
            DatabaseFeedbackFeed.email: email ?? "",
            DatabaseFeedbackFeed.message: message
        ]
        REF_FEEDBACK.addDocument(data: data) { error in
            if let error = error {
                print("FEEDBACK_ERROR: \(error)")
                handler(false)
            } else {
                handler(true)
            }
        }
    }
}


