//
//  GameZoneVoucherView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 11/01/24.
//

import SwiftUI

struct GameZoneVoucherView: View {
    var body: some View {
        LoyaltyNavBarContainerView(content: {
            AllVouchersView()
        })
        .navigationBarHidden(true)    }
}

#Preview {
    GameZoneVoucherView()
}
