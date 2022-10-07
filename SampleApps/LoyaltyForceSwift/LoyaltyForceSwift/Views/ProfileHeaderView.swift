//
//  ProfileImageView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/7/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    // TODO: replace memebrId and programName with real data
    let memberId: String = "0lM4x000000LECA"
    let programName = "NTO Insider"
    
    var body: some View {
        VStack {
            
            HStack {
                Text("My Profile")
                    .font(Font.pageTitle)
                Spacer()
            }
            .padding()
            
//            if !viewModel.isLoaded {
//                ProgressView()
//            }
            
            HStack {
                Image("img-profile-larger")
                .clipShape(Circle())
                
                VStack {
                    HStack {
                        Text("\(viewModel.profile?.associatedContact.firstName ?? "") \(viewModel.profile?.associatedContact.lastName ?? "")")
                            .font(.profileTitle)
                        Spacer()

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
        .frame(width: 375, height: 421)
        .task {
            do {
                try await viewModel.getProfileData(memberId: memberId, programName: programName)
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
