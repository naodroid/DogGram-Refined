//
//  SettingsEditTextView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/30.
//

import SwiftUI

enum SettingsEditTextOption {
    case displayName
    case bio
    
    fileprivate var title: String {
        switch self {
        case .displayName:
            return "Display Name"
        case .bio:
            return "Profile Bio"
        }
    }
    fileprivate var description: String {
        switch self {
        case .displayName:
            return "You can edit your display name here. This will be seen by other users on your profile and on your posts!"
        case .bio:
            return "Your bio is a great place to let other users know a little about you. It will be shown on your profile only."
        }
    }
    fileprivate var placeholder: String {
        switch self {
        case .displayName:
            return "Your display name here..."
        case .bio:
            return "Your bio here..."
        }
    }
}

struct SettingsEditTextView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: SettingsViewModel
    
    @State private var submissionText: String = ""
    let textOption: SettingsEditTextOption
    
    init(textOption: SettingsEditTextOption) {
        self.textOption = textOption
        let initialText: String
        switch textOption {
        case .displayName:
            initialText = viewModel.user?.displayName ?? ""
        case .bio:
            initialText = viewModel.user?.bio ?? ""
        }
        
        self._submissionText = State(wrappedValue: initialText)
    }

    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            HStack {
                Text(textOption.description)
                Spacer(minLength: 0)
            }
            
            TextField(
                textOption.placeholder,
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
        .navigationTitle(textOption.title)
        .alert(isPresented: $viewModel.showEditingFinishedAlert) { () -> Alert in
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
              let currentUserID = viewModel.user?.id
        else {
            return
        }
        switch textOption {
        case .displayName:
            //TODO
//            profileText = submissionText
//            // Update stored data
//            UserDefaults.standard.set(submissionText,
//                                      forKey: CurrentUserDefaults.displayName)
//            // Update all names on all posts from this user
//            DataService.instance.updateDisplayNameOnPosts(userID: currentUserID,
//                                                          displayName: submissionText)
//            // Update user info
//            AuthService.instance.updateUserDisplayName(
//                userID: currentUserID,
//                displayName: submissionText) { success in
//                    if success {
//                        self.showSuccessAlert = true
//                    } else {
//                        //TODO: Error alert
//                    }
//            }
            
            // FIXME: update posts that has been already fetched
            break
        case .bio:
            //TODO
//            profileText = submissionText
//            // Update stored data
//            UserDefaults.standard.set(submissionText,
//                                      forKey: CurrentUserDefaults.bio)
//            // Update user info
//            AuthService.instance.updateUserBio(
//                userID: currentUserID,
//                bio: submissionText) { success in
//                    if success {
//                        self.showSuccessAlert = true
//                    } else {
//                        //TODO: Error alert
//                    }
//            }
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
                    textOption: .displayName
                )
            }.preferredColorScheme(.light)
            NavigationView {
                SettingsEditTextView(
                    textOption: .bio
                )
            }
            .preferredColorScheme(.dark)
        }.environmentObject(SettingsViewModel(appModule: AppModule()))
    }
}
