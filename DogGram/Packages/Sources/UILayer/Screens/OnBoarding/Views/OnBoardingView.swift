//
//  OnBoardingView.swift
//  DogGram
//
//  Created by naodroid on 2021/12/05.
//

import SwiftUI
import DataLayer

struct OnBoardingView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var viewModel: OnBoardingViewModel
    
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
                viewModel.signInWithApple()
       
            } label: {
                SignInWithAppleButtonCustom()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            // MARK: Sign in gith Google
            Button {
                viewModel.signInWithGoogle()
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
            
            //anonymous
            Button {
                viewModel.signUpAsAnonymous()
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
        .fullScreenCover(isPresented: $viewModel.showOnBoardingPart2) {
            //ondismiss
            self.presentationMode.wrappedValue.dismiss()
        } content: {
            OnBoardingViewPart2()
        }
        .alert(isPresented: $viewModel.showError) {
            return Alert(title: Text("Error signing in"))
        }
        .onChange(of: viewModel.dismiss) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}

