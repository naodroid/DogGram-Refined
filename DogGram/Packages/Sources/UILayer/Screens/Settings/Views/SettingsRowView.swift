//
//  SettingsRowView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/30.
//

import SwiftUI
import DataLayer

struct SettingsRowView: View {
    var leftIcon: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                
                Image(systemName: leftIcon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
            
        }.padding(.vertical, 4)
            .foregroundColor(.primary)
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(
            leftIcon: "heart.fill",
            text: "Row Title",
            color: Color.blue
        )
            .previewLayout(.sizeThatFits)
    }
}
