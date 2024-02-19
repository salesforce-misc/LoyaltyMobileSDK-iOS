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
                                ProcessingErrorView(message: StringConstants.Referrals.genericError)
                            }
                            .padding()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                        }
                        .refreshable {
                            loadReferralsData()
                        }
                    }
                }
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .frame(maxHeight: .infinity)
            .navigationBarBackButtonHidden()

        case .loaded:
            MyReferralsView()
        }
    }
    
    func loadReferralsData() {
        Task {
            do {
                try await referralVM.getReferralsDataFromServer(memberContactId: rootVM.member?.contactId ?? "")
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
