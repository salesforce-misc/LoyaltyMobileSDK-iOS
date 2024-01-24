//
//  JoinAndReferView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/3/24.
//

import SwiftUI

struct JoinAndReferView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var referralVM: ReferralViewModel
    @EnvironmentObject private var routerPath: RouterPath
    @State private var processing: Bool = false
    
    var body: some View {
        ZStack {
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
                    processing = true
                    Task {
                        await referralVM.enroll(membershipNumber: rootVM.member?.membershipNumber ?? "")
                        processing = false
                    }
                }
                .buttonStyle(DarkLongButton())
                .disabled(processing)
                .opacity(processing ? 0.5 : 1)
                .accessibilityIdentifier(AppAccessibilty.Referrals.joinAndReferButton)
                
                Button {
                    dismiss()
                    routerPath.pathFromMore = []
                } label: {
                    Text(StringConstants.Referrals.backButton)
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
            
            if processing {
                ProgressView()
            }
        }
        .fullScreenCover(isPresented: $referralVM.displayError.0) {
            Spacer()
            ProcessingErrorView(message: referralVM.displayError.1)
            Spacer()
            Button {
                referralVM.displayError = (false, "")
            } label: {
                Text(StringConstants.Referrals.backButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .longFlexibleButtonStyle()
            .accessibilityIdentifier(AppAccessibilty.Referrals.joinErrorBackButton)
        }
        
    }
}

#Preview {
    JoinAndReferView()
        .environmentObject(ReferralViewModel())
}
