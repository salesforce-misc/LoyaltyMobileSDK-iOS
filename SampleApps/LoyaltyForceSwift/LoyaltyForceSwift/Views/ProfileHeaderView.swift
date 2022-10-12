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
            
            RewardPointsCardView()
            
            Spacer()
        }
        .frame(height: 400)
        .background(.white)
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
