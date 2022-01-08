//
//  ProfileHeaderView.swift
//  DogGram
//
//  Created by nao on 2021/11/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @ObservedObject var postArray: PostArrayObject
    @Binding var profileBio: String

    var body: some View {
        VStack(
            alignment: .center,
            spacing: 10
        ) {
            // MARK: Profile picture
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 120,
                    height: 120,
                    alignment: .center
                )
                .cornerRadius(60)
            
            // MARK: User Name
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !profileBio.isEmpty {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            HStack(
                alignment: .center,
                spacing: 20
            ) {
                // MARK: Posts
                VStack(
                    alignment: .center,
                    spacing: 5
                ) {
                    Text("\(postArray.postCountString)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Capsule()
                        .fill(Color.gray)
                        .frame(
                            width: 20,
                            height: 2,
                            alignment: .center
                        )
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                }
                // MARK: Likes
                VStack(
                    alignment: .center,
                    spacing: 5
                ) {
                    Text(postArray.likeCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    Capsule()
                        .fill(Color.gray)
                        .frame(
                            width: 20,
                            height: 2,
                            alignment: .center
                        )
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var profileDisplayName: String = "Joe"
    @State static var profileImage: UIImage = UIImage(named: "logos.logo")!
    @State static var profileBio: String = "Bio"

    static var previews: some View {
        ProfileHeaderView(
            profileDisplayName: $profileDisplayName,
            profileImage: $profileImage,
            postArray: PostArrayObject(),
            profileBio: $profileBio
        )
            .previewLayout(.sizeThatFits)
    }
}
