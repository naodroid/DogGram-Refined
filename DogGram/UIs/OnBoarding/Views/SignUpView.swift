//
//  SignUpView.swift
//  DogGram
//
//  Created by nao on 2021/11/30.
//

import SwiftUI

struct SignUpView: View {
    @State var showOnBoarding = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 20
        ) {
            Spacer()
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 100,
                    height: 100,
                    alignment: .center
                )
            
            Text("You're not signed in 😕")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.purpleColor)

            Text("Click the button below to create an account and join the fun!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Button {
                showOnBoarding = true
            } label: {
                Text("Sign in / Sign up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            }.accentColor(Color.MyTheme.yellowColor)

            Spacer()
            Spacer()
        }
        .padding(.all, 40)
        .background(Color.MyTheme.yellowColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnBoarding) {
            
        } content: {
            OnBoardingScreen()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
                .preferredColorScheme(.light)
            SignUpView()
                .preferredColorScheme(.dark)
        }
    }
}
