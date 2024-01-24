//
//  ReferralsGatewayView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/18/24.
//

import SwiftUI

struct ReferralsGatewayView: View {
    @StateObject private var referralVM = ReferralViewModel()
    @EnvironmentObject private var rootVM: AppRootViewModel
    @State var isEnrolled = false
    
    var body: some View {
            
        VStack {
            if isEnrolled {
                MyReferralsView()
                    .environmentObject(referralVM)
            } else {
                MyReferralsView(showJoinandReferView: true)
                    .environmentObject(referralVM)
            }
            
        }
        .task {
            isEnrolled = await referralVM.isMemberEnrolled(membershipNumber: rootVM.member?.membershipNumber ?? "")
        }
    }
}

#Preview {
    ReferralsGatewayView()
        .environmentObject(AppRootViewModel())
}
