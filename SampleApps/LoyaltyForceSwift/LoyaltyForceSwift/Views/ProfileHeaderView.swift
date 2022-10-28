//
//  ProfileImageView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/7/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image("img-profile-larger")
                .clipShape(Circle())
                
                VStack {
                    HStack {
                        Text("\(viewModel.member?.firstName ?? "") \(viewModel.member?.lastName ?? "")")
                            .font(.profileTitle)
                        Spacer()

                    }
                    HStack {
                        Text(viewModel.member?.enrollmentDetails.membershipNumber ?? "")
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

    }
    
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .previewLayout(.sizeThatFits)
            .environmentObject(dev.rootVM)
    }
}
