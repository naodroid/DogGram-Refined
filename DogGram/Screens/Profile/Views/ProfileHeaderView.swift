//
//  ProfileHeaderView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel

    var body: some View {
        VStack(
            alignment: .center,
            spacing: 10
        ) {
            // MARK: Profile picture
            Image(uiImage: viewModel.profileImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 120,
                    height: 120,
                    alignment: .center
                )
                .cornerRadius(60)
            
            // MARK: User Name
            Text(viewModel.user?.displayName ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let bio = viewModel.user?.bio, !bio.isEmpty {
                Text(bio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            HStack(
                alignment: .center,
                spacing: 20
            ) {
                // MARK: Posts
                // TODO
                VStack(
                    alignment: .center,
                    spacing: 5
                ) {
                    Text("TODO")
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
                // TODO
                VStack(
                    alignment: .center,
                    spacing: 5
                ) {
                    Text("TODO")
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

    static var previews: some View {
        ProfileHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
