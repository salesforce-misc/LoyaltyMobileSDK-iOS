//
//  JoinAndReferView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/3/24.
//

import SwiftUI

struct JoinAndReferView: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image("img-join")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geometry.size.width, maxHeight: 160)
                    .clipped()
            }
            .frame(maxHeight: 160)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("**Refer a Friend and Earn**")
                    .font(.referModalText)
                    .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                Text("Invite your friends and get a voucher when they shop for the first time. Join the referral program to start.")
                    .lineSpacing(5)
                    .font(.referModalText)
                Text("Tap 'Join and Refer' to participate. By joining you agree to the terms and conditions.")
                    .lineSpacing(5)
                    .font(.referModalText)
                
            }
            .padding()
            
            Button("Join and Refer") {
                
            }
            .buttonStyle(DarkLongButton())

            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    JoinAndReferView()
}
