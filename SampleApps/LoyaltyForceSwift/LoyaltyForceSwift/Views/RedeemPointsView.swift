//
//  RedeemPointsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/8/22.
//

import SwiftUI

struct RedeemPointsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Redeem Points")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                LoyaltyNavLink {
                    AllRedeemPointsView()
                } label: {
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                }

            }
            .padding()
            
            HStack {
                Spacer()
                RedeemCardView()
                Spacer()
                RedeemCardView()
                Spacer()
            }
            
        }
        .frame(height: 400)
        //.background(Color.theme.background)
    }
}

struct RedeemPointsView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemPointsView()
    }
}
