//
//  UploadView.swift
//  DogGram
//
//  Created by nao on 2021/11/21.
//
import SwiftUI
import UIKit

struct UploadView: View {
    @State var showImagePicker = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var showPostImageView = false
    @State var showOnBoarding = false
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?

    var body: some View {
        ZStack {
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                Button(action: {
                    if currentUserID != nil {
                        sourceType = .camera
                        showImagePicker = true
                    } else {
                        showOnBoarding = true
                    }
                }) {
                    Text("Take Photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.yellowColor)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .center)
                .background(Color.MyTheme.purpleColor)
                
                Button(action: {
                    if currentUserID != nil {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    } else {
                        showOnBoarding = true
                    }
                }) {
                    Text("Imort photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.purpleColor)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .center)
                .background(Color.MyTheme.yellowColor)
            }
            .sheet(isPresented: $showImagePicker) {
                segueToPostImageView()
            } content: {
                ImagePicker(imageSelected: $imageSelected,
                            sourceType: $sourceType)
            }
            
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 20)
                .fullScreenCover(isPresented: $showPostImageView) {
                    
                } content: {
                    PostImageView(
                        imageSelected: $imageSelected)
                        .preferredColorScheme(colorScheme)
                        .accentColor(colorScheme == .light
                                     ? Color.MyTheme.purpleColor
                                     : Color.MyTheme.yellowColor
                        )
                }
            
        }
        .edgesIgnoringSafeArea(.top)
        .loggedInGuard(showOnBoarding: $showOnBoarding)
    }
    
    // MARK: functions
    func segueToPostImageView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPostImageView.toggle()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            .colorScheme(.light)
        UploadView()
            .colorScheme(.dark)
    }
}
