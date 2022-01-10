//
//  SignInWithGoogle.swift
//  DogGram
//
//  Created by nao on 2021/12/15.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

// TODO: Multi Factor Authentication
class SignInWithGoogle: NSObject {
    /// Start SignIn with google, without MultiFactorAuth
    @MainActor
    func start() async throws -> SignInResult {
        return try await withCheckedThrowingContinuation({ continuation in
            guard
                let clientID = FirebaseApp.app()?.options.clientID
            else {
                continuation.resume(throwing: NSError())
                return
            }
            let config = GIDConfiguration(clientID: clientID)
            // Start the sign in flow!
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first!
                .windows
                .filter { $0.isKeyWindow }
                .first!
            let vc = keyWindow.rootViewController!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, error in
                
                guard let user = user,
                      let name = user.profile?.name,
                      let email = user.profile?.email
                else {
                    let e = error ?? NSError()
                    continuation.resume(throwing: e)
                    return
                }
                let authentication = user.authentication
                guard let idToken = authentication.idToken else {
                    continuation.resume(throwing: NSError())
                    return
                }
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: authentication.accessToken
                )
                let result = SignInResult(email: email,
                                          name: name,
                                          provider: "google",
                                          credential: credential)
                continuation.resume(returning: result)
            }
        })
    }
}
