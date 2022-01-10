//
//  LoggedInGuard.swift
//  DogGram
//
//  Created by nao on 2022/01/08.
//

import SwiftUI

struct LoggedInGuard: ViewModifier {
    @Binding var showOnBoarding: Bool
    
    func body(content: Content) -> some View {
        return content.fullScreenCover(isPresented: $showOnBoarding) {
        } content: {
            OnBoardingScreen()
        }
    }
}
extension View {
    func loggedInGuard(showOnBoarding: Binding<Bool>) -> some View {
        return self.modifier(LoggedInGuard(showOnBoarding: showOnBoarding))
    }
}

