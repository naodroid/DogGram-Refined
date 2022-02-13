//
//  SignInWithAppleButtonCustom.swift
//  DogGram
//
//  Created by naodroid on 2021/12/05.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonCustom: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return ASAuthorizationAppleIDButton(
            authorizationButtonType: .default,
            authorizationButtonStyle: .black
        )
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
