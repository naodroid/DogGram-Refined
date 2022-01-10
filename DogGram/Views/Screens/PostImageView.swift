//
//  PostImageView.swift
//  DogGram
//
//  Created by nao on 2021/11/24.
//

import SwiftUI

struct PostImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var captionText: String = ""
    @Binding var imageSelected: UIImage
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currestUserDisplayName: String?
    
    @State var showAlert = false
    @State var postUploadedSuccessfully = false
    
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
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                TextField(
                    "Add your caption here...",
                    text: $captionText)
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
                    postPicture()
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
            .alert(isPresented: $showAlert) {() -> Alert in
                getAlert()
            }
        }
    }
    
    
    // MARK: Functions
    func postPicture() {
        guard let userID = currentUserID,
              let displayName = currestUserDisplayName
        else {
            return
        }
        
        DataService.instance.uploadPost(image: imageSelected,
                                        caption: captionText,
                                        displayName: displayName,
                                        userID: userID) { success in
            if success {
                postUploadedSuccessfully = true
            }
            showAlert = true
        }
        print("POST PICTURES TO DATABASE HERE")
    }
    func getAlert() -> Alert {
        if postUploadedSuccessfully {
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
        } else {
            return Alert(title: Text("Error uploading post"))
        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        Group {
            PostImageView(imageSelected: PostImageView_Previews.$image)
                .preferredColorScheme(.dark)
        }
    }
}
