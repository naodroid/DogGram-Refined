//
//  AuthService.swift
//  DogGram
//
//  Created by nao on 2021/12/18.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

let DB_BASE = Firestore.firestore()

/// used to authenticate sures in Firebase
/// used to handle user accounts in Firebase
class AuthService {
    // MARK: properties
    static let instance = AuthService()
    
    private var REF_USERS = DB_BASE.collection("users")
    private let signInWithApple = SignInWithApple()
    
    
    // MARK: Auth user functions
    func logInUserToFirebase(credential: AuthCredential,
                             handler: @escaping (_ providerID: String?,
                                                 _ isError: Bool,
                                                 _ isNewUser: Bool?,
                                                 _ userID: String?) -> ()
    ) {
        
        Auth.auth().signIn(with: credential) { result, error in
            if error != nil {
                handler(nil, true, nil, nil)
                return
            }
            guard let providerID = result?.user.uid else {
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerID) { existingUserID in
                if let userID = existingUserID {
                    // existing user
                    handler(providerID, false, false, userID)
                } else {
                    // new user
                    handler(providerID, false, true, nil)
                }
            }
        }
    }
    
    func loginUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        getUserInfo(forUserID: userID) { name, bio in
            if let name = name, let bio = bio {
                handler(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                }
            } else {
                handler(false)
            }
        }
    }

    
    func createNewUserInDatabase(
        name: String,
        email: String,
        providerID: String,
        provider: String,
        profileImage: UIImage,
        handler: @escaping (_ userID: String?) -> ()
    ) {
        let document = REF_USERS.document()
        let userID = document.documentID
        //upload profile image to storage
        ImageManager.instance.uploadProfileImage(userID: userID,
                                                 image: profileImage) { success in
            
        }
        //set user data
        let userData: [String: Any] = [
            DatabaseUserField.displayName: name,
            DatabaseUserField.email: email,
            DatabaseUserField.providerId: providerID,
            DatabaseUserField.provider: provider,
            DatabaseUserField.userID: userID,
            DatabaseUserField.bio: "",
            DatabaseUserField.dateCreated: FieldValue.serverTimestamp()
        ]
        document.setData(userData) { error in
            if let error = error {
                print("Error uploading data to user document. \(error)")
                handler(nil)
                return
            }
            handler(userID)
        }
    }
    
    private func checkIfUserExistsInDatabase(providerID: String,
                                             handler: @escaping (_ existingUserID: String?) -> ()
    ) {
        // If a userID is returned, then the user does exist in our database
        REF_USERS.whereField(DatabaseUserField.userID, isEqualTo: providerID)
            .getDocuments { (snapshot, error) in
                if let snapshot = snapshot,
                    snapshot.count > 1,
                    let document = snapshot.documents.first {
                    let existingUserID = document.documentID
                    handler(existingUserID)
                } else {
                    handler(nil)
                }
            }
    }
    
    // MARK: get user functions
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ bio: String?) -> ()) {
        
        REF_USERS.document(userID).getDocument { snapshot, error in
            if let document = snapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                handler(name, bio)
            } else {
                handler(nil, nil)
            }
        }
    }
    
    func logOutUser(handler: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            handler(true)
        } catch {
            handler(false)
        }
    }
    /// Delete account "ONLY"
    /// you need to delete posts, comments and images before this
    /// If user wasn't created,  failure result will be passed to the handler
    func deleteUser(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        guard let user = Auth.auth().currentUser else {
            handler(false)
            return
        }
        user.delete(completion: { error in
            handler(error == nil)
        })        
    }
    
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping (_ success: Bool) -> ()) {
        let data: [String: Any] = [
            DatabaseUserField.displayName: displayName
        ]
        REF_USERS.document(userID).updateData(data) { error in
            handler(error == nil)
        }
    }
    func updateUserBio(userID: String, bio: String, handler: @escaping (_ success: Bool) -> ()) {
        let data: [String: Any] = [
            DatabaseUserField.bio: bio
        ]
        REF_USERS.document(userID).updateData(data) { error in
            handler(error == nil)
        }
    }
}
