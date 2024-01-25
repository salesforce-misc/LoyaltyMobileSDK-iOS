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
                    Text("**\(StringConstants.Referrals.joinTitle)**")
                        .font(.referModalText)
                        .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                    Text(StringConstants.Referrals.joinText)
                        .lineSpacing(5)
                        .font(.referModalText)
                }
                .padding()
                Spacer()
                Button(StringConstants.Referrals.joinButton) {
                    processing = true
                    Task {
                        // await referralVM.enroll(membershipNumber: rootVM.member?.membershipNumber ?? "")
                        await referralVM.enroll(contactId: rootVM.member?.contactId ?? "")
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
