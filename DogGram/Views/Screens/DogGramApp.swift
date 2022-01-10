//
//  DogGramApp.swift
//  DogGram
//
//  Created by nao on 2021/11/18.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct DogGramApp: App {
    
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    @State private var appModule = AppModule()
    
    init() {
        // in iOS15, Navigation Header will be transparent.
        // Set color manually to avoid this effect.
        // TODO: update colors
        let appearace = UINavigationBarAppearance()
        appearace.configureWithOpaqueBackground()
        appearace.backgroundColor = UIColor.tertiarySystemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = appearace
        UINavigationBar.appearance().standardAppearance = appearace
        UINavigationBar.appearance().tintColor = .gray
        UINavigationBar.appearance().barTintColor = .gray
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .environment(\.appModule, appModule)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}



