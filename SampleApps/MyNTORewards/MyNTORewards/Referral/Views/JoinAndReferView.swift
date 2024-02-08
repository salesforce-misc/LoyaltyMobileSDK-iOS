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
    @Binding var showReferAFriendView: Bool
    var isFromMyReferralView: Bool = false

    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Image("img-join")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width, maxHeight: 241)
                        .clipped()
                }
                .frame(maxHeight: 241)
                
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
                        if isFromMyReferralView {
                            await referralVM.enroll(contactId: rootVM.member?.contactId ?? "")
                            processing = false
                            dismiss()
                            if !referralVM.displayError.0 {
                                showReferAFriendView = true
                            }

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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        routerPath.pathFromMore = []
                    }
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
    JoinAndReferView(showReferAFriendView: .constant(false))
        .environmentObject(ReferralViewModel())
}
