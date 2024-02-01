//
//  ReferralsGatewayView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/18/24.
//

import SwiftUI

struct ReferralsGatewayView: View {
    @EnvironmentObject private var referralVM: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    
    var body: some View {
        switch referralVM.enrollmentStatusApiState {
        case .idle:
            Color.theme.background.onAppear(perform: checkEnrollmentStatus)
        case .loading:
            VStack(spacing: 0) {
                HStack {
                    Text(StringConstants.Referrals.referralsTitle)
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                        .accessibilityIdentifier(AppAccessibilty.Referrals.referralsViewTitle)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(.white)
                ZStack {
                    Color.theme.background
                    ProgressView()
                }
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .frame(maxHeight: .infinity)
            .navigationBarBackButtonHidden()
        case .failed:
            ProcessingErrorView(message: "Oops! Something went wrong while processing the request. Try again.")
        case .loaded:
            MyReferralsView()
        }
    }
    
    func checkEnrollmentStatus() {
        Task {
            await referralVM.checkEnrollmentStatus(contactId: rootVM.member?.contactId ?? "")
        }
    }
}

#Preview {
    ReferralsGatewayView()
        .environmentObject(AppRootViewModel())
}
