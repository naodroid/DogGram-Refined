//
//  OnBoardingView.swift
//  DogGram
//
//  Created by nao on 2021/12/05.
//

import SwiftUI
import FirebaseAuth

struct OnBoardingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var showOnBoardingPart2 = false
    @State var showError = false
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                }
                .accentColor(.primary)
                
                Spacer()
            }
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            Text("Welcome to DogGram!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            Text("DogGram is the #1 app for pictures of your dog and sharing them across the world. We are a dog-loving community and we're happy to have you!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                .padding()
            
            // MARK: Sign in with apple
            Button {
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)                
            } label: {
                SignInWithAppleButtonCustom()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            // MARK: Sign in gith Google
            Button {
                SignInWithGoogle.instance.startSignInWithGoogle(view: self)
                showOnBoardingPart2 = true
            } label: {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign In with Google")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.sRGB, red: 0.8, green: 0.3, blue: 0.3, opacity: 1.0))
                .cornerRadius(9)
                .font(.system(size: 22, weight: .medium, design: .default))
            }
            .accentColor(Color.white)
            
            //annonymous
            Button {
                self.signUpAsAnnonymous()
            } label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            }
            .accentColor(Color.black)
            
        }
        .padding(.all, 20)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnBoardingPart2) {
            //ondismiss
            self.presentationMode.wrappedValue.dismiss()
        } content: {
            OnBoardingViewPart2(
                displayName: $displayName,
                email: $email,
                providerID: $provider,
                provider: $provider
            )
        }
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error signing in 😭"))
        }
    }
    
    // MARK: functions
    func connectToFirebase(name: String,
                           email: String,
                           provider: String,
                           credential: AuthCredential) {
        AuthService.instance.logInUserToFirebase(credential: credential) {
            providerID, isError, isNewUser, userID in
            
            if let newUser = isNewUser {
                if newUser {
                    // new user
                    if let providerID = providerID, !isError {
                        // New user, continue to onboarding part2
                        self.displayName = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        self.showOnBoardingPart2 = true
                    } else {
                        print("Error getting info from log in user to Firebase")
                        self.showError = true
                    }
                } else {
                    // existing user
                    if let userID = userID {
                        AuthService.instance.loginUserToApp(userID: userID) { success in
                            if success {
                                print("Successful log in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.showError = true
                            }
                        }
                    } else {
                        self.showError = true
                    }
                }
            } else {
                self.showError = true
            }
        }
    }
    func signUpAsAnnonymous() {
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                self.showError = true
                return
            }
            let uid = user.uid
            self.displayName = ""
            self.email = ""
            self.providerID = "annonymous"
            self.provider = uid
            self.showOnBoardingPart2 = true
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}

