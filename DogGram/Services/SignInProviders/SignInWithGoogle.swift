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
    
    
    static let instance = SignInWithGoogle()
    var onboardingView: OnBoardingView!
    
    /// Start SignIn with google, without MultiFactorAuth
    func startSignInWithGoogle(view: OnBoardingView) {
        self.onboardingView = view
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
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
        //
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { [unowned self] user, error in
            
            if let error = error {
                print(error)
                self.onboardingView.showError = true
                return
            }
            guard let user = user,
                  let name = user.profile?.name,
                  let email = user.profile?.email
            else {
                self.onboardingView.showError = true
                return
            }
            let authentication = user.authentication
            guard let idToken = authentication.idToken else {
                self.onboardingView.showError = true
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            onboardingView.connectToFirebase(name: name,
                                             email: email,
                                             provider: "google",
                                             credential: credential)
        }
    }
}
