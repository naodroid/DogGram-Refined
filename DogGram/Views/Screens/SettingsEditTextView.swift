//
//  SettingsEditTextView.swift
//  DogGram
//
//  Created by nao on 2021/11/30.
//

import SwiftUI

enum SettingsEditTextOption {
    case displayName
    case bio
}

struct SettingsEditTextView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @Binding var profileText: String
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    @State var showSuccessAlert: Bool = false

    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            TextField(
                placeholder,
                text: $submissionText
            )
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light
                            ? Color.MyTheme.beigeColor
                            : Color.MyTheme.purpleColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            Button {
                saveText()
            } label: {
                Text("Save".uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            }
            .accentColor(colorScheme == .light
                         ? Color.MyTheme.yellowColor
                         : Color.MyTheme.purpleColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(title)
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            Alert(title: Text("Saved!"),
                  message: nil,
                  dismissButton: .default(
                    Text("OK"),
                    action: {
                        dismissView()
                    }
                  )
            )
        }
        
    }
    
    // MARK: functions
    
    func dismissView() {
        self.haptics.notificationOccurred(.success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // TODO: This method is the same as CommentsView.
    // Separate the logic from View, and Resue it
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innappropriate things
        let badWordArray: [String] = ["shit", "ass"]
        let words = submissionText.components(separatedBy: " ")
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    func saveText() {
        guard textIsAppropriate(),
        let currentUserID = currentUserID
        else {
            return
        }
        switch settingsEditTextOption {
        case .displayName:
            profileText = submissionText
            // Update stored data
            UserDefaults.standard.set(submissionText,
                                      forKey: CurrentUserDefaults.displayName)
            // Update all names on all posts from this user
            DataService.instance.updateDisplayNameOnPosts(userID: currentUserID,
                                                          displayName: submissionText)
            // Update user info
            AuthService.instance.updateUserDisplayName(
                userID: currentUserID,
                displayName: submissionText) { success in
                    if success {
                        self.showSuccessAlert = true
                    } else {
                        //TODO: Error alert
                    }
            }
            
            // FIXME: update posts that has been already fetched
        case .bio:
            profileText = submissionText
            // Update stored data
            UserDefaults.standard.set(submissionText,
                                      forKey: CurrentUserDefaults.bio)
            // Update user info
            AuthService.instance.updateUserBio(
                userID: currentUserID,
                bio: submissionText) { success in
                    if success {
                        self.showSuccessAlert = true
                    } else {
                        //TODO: Error alert
                    }
            }
            break
        }
    }

}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var profileText = "ABC"
    static var previews: some View {
        Group {
            NavigationView {
                SettingsEditTextView(
                    title: "Edit Display Name",
                    description: "Description",
                    placeholder: "Place Holder",
                    settingsEditTextOption: .displayName,
                    profileText: $profileText
                )
            }.preferredColorScheme(.light)
            NavigationView {
                SettingsEditTextView(
                    title: "Edit Display Name",
                    description: "Description",
                    placeholder: "Place Holder",
                    settingsEditTextOption: .bio,
                    profileText: $profileText
                )
            }
            .preferredColorScheme(.dark)
        }
    }
}
