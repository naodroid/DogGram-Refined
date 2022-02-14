//
//  OnBordingViewPart2.swift
//  DogGram
//
//  Created by naodroid on 2021/12/05.
//

import SwiftUI
import DataLayer

struct OnBoardingViewPart2: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: OnBoardingViewModel
    
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            TextField(
                "Add your name here",
                text: $viewModel.displayName
            )
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .foregroundColor(Color.black)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button {
                showImagePicker = true
            } label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            .opacity(viewModel.displayName.isEmpty ? 0.2 : 1.0)
            .animation(.easeInOut)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker) {
            viewModel.createProfile()
        } content: {
            ImagePicker(
                imageSelected: $viewModel.imageSelected,
                sourceType: sourceType
            )
        }
        .alert(isPresented: $viewModel.showError) {
            return Alert(title: Text("Error creating Profile"))
        }
        .onChange(of: viewModel.dismiss) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
        
}

struct OnBoardingViewPart2_Previews: PreviewProvider {
    
    static let viewModel = OnBoardingViewModel(appModule: AppModule())
    
    static var previews: some View {
        OnBoardingViewPart2()
            .environmentObject(viewModel)
            .preferredColorScheme(.dark)
    }
}
