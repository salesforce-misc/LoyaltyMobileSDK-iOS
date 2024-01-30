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
            
        VStack {
            MyReferralsView()
        }
        .task {
            await referralVM.getMembershipNumber(contactId: rootVM.member?.contactId ?? "")
            // isEnrolled = await referralVM.checkEnrollmentStatus(membershipNumber: rootVM.member?.membershipNumber ?? "")
        }
    }
}

#Preview {
    ReferralsGatewayView()
        .environmentObject(AppRootViewModel())
}
