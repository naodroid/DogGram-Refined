//
//  SignInWithApple.swift
//  DogGram
//
//  Created by naodroid on 2021/12/08.
//

import Foundation
import AuthenticationServices
import SwiftUI
import CryptoKit
import FirebaseAuth

final class SignInWithApple: NSObject {
    
    // Unhashed nonce.
    private var currentNonce: String?
    private var checkContinuation: CheckedContinuation<SignInResult, Error>?
    
    func start() async throws -> SignInResult {
        return try await withCheckedThrowingContinuation { continuatioln in
            self.checkContinuation = continuatioln
            self.showUI()
        }
    }
    private func showUI() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func resumeContinuation(result: Result<SignInResult, Error>) {
        checkContinuation?.resume(with: result)
        checkContinuation = nil
    }
}

// MARK: ASAuthorizationControllerDelegate
extension SignInWithApple: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce
        else {
            //TODO: Fix error type
            resumeContinuation(result: .failure(NSError()))
            return
        }
        let email = appleIDCredential.email ?? ""
        var name = "Your name here"
        if let fullName = appleIDCredential.fullName {
            let formatter = PersonNameComponentsFormatter()
            name = formatter.string(from: fullName)
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        let result = SignInResult(email: email,
                                  name: name,
                                  provider: "apple",
                                  credential: credential)
        resumeContinuation(result: .success(result))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        resumeContinuation(result: .failure(error))
    }
}

extension SignInWithApple: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
}


private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}




// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}
