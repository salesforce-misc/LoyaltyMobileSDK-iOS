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
    @EnvironmentObject private var promotionGateWayViewModel: PromotionGateWayViewModel
    @EnvironmentObject private var routerPath: RouterPath
    @State private var processing: Bool = false
    var isFromMyReferralView: Bool = false
    let promotion: ReferralPromotionObject?
    
    var body: some View {
        // swiftlint:disable:next line_length
        let termsText: String = ("\(StringConstants.Referrals.termsText) [\(StringConstants.Referrals.termsLinkText)](\(AppSettings.Defaults.referralTermsLink)).")
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Group {
                        if promotion?.promotionImageUrl != nil {
                            LoyaltyAsyncImage(url: promotion?.promotionImageUrl, content: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            }, placeholder: {
                                ProgressView()
                            })
                        } else {
                            Image("img-join")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(maxWidth: geometry.size.width, maxHeight: 241)
                    .clipped()
                }
                .frame(maxHeight: 241)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("**\(promotion?.name ?? "")**")
                        .font(.referModalNameText)
                        .foregroundStyle(Color.theme.lightText)
                        .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                    Group {
                        Text(promotion?.description ?? "")
                        Text(termsText.markdownToAttributed())
                    }
                    .lineSpacing(5)
                    .font(.referModalText)
                    .foregroundStyle(Color.theme.superLightText)
                }
                .padding()
                Spacer()
                Button(StringConstants.Referrals.joinButton) {
                    processing = true
                    Task {
                        if isFromMyReferralView {
                            await referralVM.enroll(contactId: rootVM.member?.contactId ?? "")
                            processing = false
                        } else {
                            await  promotionGateWayViewModel.enroll(contactId: rootVM.member?.contactId ?? "")
                            processing = false
                        }
                    }
                }
                .buttonStyle(DarkLongButton())
                .disabled(processing)
                .opacity(processing ? 0.5 : 1)
                .accessibilityIdentifier(AppAccessibilty.Referrals.joinAndReferButton)
                
                Button {
                    dismiss()
                } label: {
                    Text(StringConstants.Referrals.backButton)
                        .frame(maxWidth: .infinity)
                }.padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden()
            
            if processing {
                ProgressView()
            }
        }
        
    }
}

#Preview {
    JoinAndReferView(promotion: nil)
        .environmentObject(ReferralViewModel())
}
