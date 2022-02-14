//
//  UploadView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/21.
//
import SwiftUI
import UIKit
import SwiftUI
import DataLayer

struct UploadView: View {
    @EnvironmentObject private var viewModel: UploadViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(
                alignment: .center,
                spacing: 0
            ) {
                Button(action: {
                    viewModel.onCameraClick()
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
                    viewModel.onImportClick()
                }) {
                    Text("Import photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.purpleColor)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .center)
                .background(Color.MyTheme.yellowColor)
            }
            .sheet(isPresented: viewModel.showImagePicker) {
                viewModel.onImageSelected()
            } content: {
                ImagePicker(imageSelected: $viewModel.imageSelected,
                            sourceType: viewModel.sourceType ?? .photoLibrary)
            }
            
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 20)
                .fullScreenCover(isPresented: $viewModel.showPostImageView) {
                    
                } content: {
                    PostImageScreen(imageSelected: viewModel.imageSelected)
                        .preferredColorScheme(colorScheme)
                        .accentColor(colorScheme == .light
                                     ? Color.MyTheme.purpleColor
                                     : Color.MyTheme.yellowColor
                        )
                }
            
        }
        .edgesIgnoringSafeArea(.top)
        .loggedInGuard(showOnBoarding: $viewModel.showOnBoarding)
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
