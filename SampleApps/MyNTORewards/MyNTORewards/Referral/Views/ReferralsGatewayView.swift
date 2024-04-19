//
//  ReferralsGatewayView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/18/24.
//

import SwiftUI
import ReferralMobileSDK

struct ReferralsGatewayView: View {
    @EnvironmentObject private var referralVM: ReferralViewModel
    @EnvironmentObject private var rootVM: AppRootViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var loyaltyFeatureManager = LoyaltyFeatureManager.shared
    
    var body: some View {
        switch referralVM.loadAllReferralsApiState {
        case .idle:
            Color.theme.background.onAppear(perform: loadReferralsData)
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
                    GeometryReader { geometry in
                        ScrollView(.vertical) {
                            VStack {
                                Spacer()
                                // swiftlint:disable:next line_length
                                ProcessingErrorView(message: loyaltyFeatureManager.isReferralFeatureEnabled ? StringConstants.Referrals.genericError: StringConstants.Referrals.notEnabledMessage)
                                Spacer()
                                Button {
                                    dismiss()
                                } label: {
                                    Text(StringConstants.Referrals.backButton)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .longFlexibleButtonStyle()
                            }
                            .padding()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                        }
                        .refreshable {
                            loadReferralsData()
                            LoyaltyFeatureManager.shared.checkIsReferralFeatureEnabled()
                        }
                    }
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .navigationBarBackButtonHidden()

        case .loaded:
            MyReferralsView()
        }
    }
    
    func loadReferralsData() {
        Task {
            do {
                try await referralVM.getReferralsDataFromServer(membershipNumber: rootVM.member?.membershipNumber ?? "")
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ReferralsGatewayView()
        .environmentObject(AppRootViewModel())
}
