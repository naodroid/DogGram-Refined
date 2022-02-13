//
//  SettingsEditTextView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/30.
//

import SwiftUI

struct SettingsEditImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: SettingsEditImageViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(viewModel.description)
                Spacer(minLength: 0)
            }
            
            Image(uiImage: viewModel.selectedImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 200,
                    height: 200,
                    alignment: .center
                )
                .clipped()
                .cornerRadius(12)
            
            Button {
                viewModel.onImportClick()
            } label: {
                Text("Import".uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $viewModel.showImagePicker) {
                
            } content: {
                ImagePicker(
                    imageSelected: $viewModel.selectedImage,
                    sourceType: viewModel.sourceType
                )
            }
            
            
            Button {
                viewModel.saveImage()
            } label: {
                Text("Save".uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.yellowColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(viewModel.title)
        .alert(isPresented: $viewModel.showSuccessAlert) { () -> Alert in
            Alert(title: Text("Saved!"),
                  message: nil,
                  dismissButton: .default(
                    Text("OK"),
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                  )
            )
        }
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    @State static var profileImage: UIImage = UIImage(named: "dog1")!
    static var previews: some View {
        NavigationView {
            SettingsEditImageView().environmentObject(SettingsEditImageViewModel(appModule: AppModule(), title: "", description: ""))
        }
    }
}

