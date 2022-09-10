//
//  ProfileImageView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/7/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    private let memberId: String = "0lM4x000000LECA"
    
    
    var body: some View {
        VStack {
            
            HStack {
                Text("My Profile")
                    .font(Font.pageTitle)
                Spacer()
            }
            .padding()
            
            HStack {
                Image("img-profile-larger")
                .clipShape(Circle())
                
                VStack {
                    HStack {
                        Text("\(viewModel.profile?.associatedContact.firstName ?? "") \(viewModel.profile?.associatedContact.lastName ?? "")")
                            .font(.profileTitle)
                        Spacer()
                        Button {
                            //
                        } label: {
                            Label("Edit", image: "ic-edit")
                                .font(.editText)
                        }

                    }
                    HStack {
                        Text(viewModel.profile?.membershipNumber ?? "")
                            .foregroundColor(Color.theme.textInactive)
                            .font(.profileSubtitle)
                        Spacer()
                    }
                    
                }

                Spacer()
            }
            .padding()
            
            ZStack {
                Image("img-card-base")
                HStack {
                    Spacer()
                    Image("img-card-layer1")
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("img-card-layer2")
                    }
                }

            }
            
            Spacer()
        }
        .frame(width: 375, height: 344)
        .task {
            do {
                try await viewModel.getProfileData(memberId: memberId)
            } catch {
                print("Fetch Benefits Error: \(error.localizedDescription)")
            }

        }

    }
    
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
