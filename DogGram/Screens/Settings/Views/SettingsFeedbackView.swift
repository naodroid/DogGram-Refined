//
//  SettingsFeedbackView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/30.
//

import SwiftUI

struct SettingsFeedbackView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var emailText: String = ""
    @State var message: String = ""
    @State var showSuccessAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Please post your feedback to improve this software!")
                Spacer(minLength: 0)
            }
            
            TextField(
                "Enter your email address(Optional)",
                text: $emailText
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
            TextField(
                "Feedback",
                text: $message
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
                postFeedback()
            } label: {
                Text("Upload!".uppercased())
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
        .navigationTitle("Feedback")
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            Alert(title: Text("Saved!"),
                  message: Text("Thank you for your feedback!"),
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
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func postFeedback() {
        DataService.instance.uploadFeedback(
            email: emailText,
            message: message) { success in
                if success {
                    self.showSuccessAlert = true
                }
                //TODO: Error alert
            }
    }
    
}

struct SettingsFeedbackView_Previews: PreviewProvider {
    @State static var profileText = "ABC"
    static var previews: some View {
        Group {
            NavigationView {
                SettingsFeedbackView(
                )
            }.preferredColorScheme(.light)
            NavigationView {
                SettingsFeedbackView(
                )
            }
            .preferredColorScheme(.dark)
        }
    }
}

