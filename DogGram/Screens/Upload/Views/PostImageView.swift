//
//  PostImageView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/24.
//

import SwiftUI

struct PostImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: PostImageViewModel
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
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
            
            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                Image(uiImage: viewModel.imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                TextField(
                    "Add your caption here...",
                    text: $viewModel.captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light
                                ? Color.MyTheme.beigeColor
                                : Color.MyTheme.purpleColor)
                    .font(.headline)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .autocapitalization(.sentences)
                
                Button {
                    viewModel.postPicture()
                } label: {
                    Text("POST PICTURE!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .light
                                    ? Color.MyTheme.purpleColor
                                    : Color.MyTheme.yellowColor)
                        .font(.headline)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .autocapitalization(.sentences)
                }
                .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
            }
            .alert(isPresented: $viewModel.showAlert) {() -> Alert in
                getAlert(for: viewModel.alertType ?? .initializingFailed(message: "Unknown Error Happened"))
            }
        }
    }
    private func getAlert(for alertType: PostImageAlertType) -> Alert {
        switch alertType {
        case .postFinished:
            return Alert(
                title: Text("Successfully uploaded post!"),
                message: nil,
                dismissButton: .default(
                    Text("OK"),
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            )
        case .initializingFailed(let message):
            return Alert(
                title: Text(message),
                message: nil,
                dismissButton: .default(
                    Text("OK"),
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            )
        case .postFailed(let message):
            return Alert(title: Text(message))
        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        Group {
            PostImageView()
                .preferredColorScheme(.dark)
        }
    }
}
