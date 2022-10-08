//
//  RedeemCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/8/22.
//

import SwiftUI

struct RedeemCardView: View {
    var body: some View {
        
        VStack {
            Image("redeem1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 165, height: 90)
                .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Best Selling Items")
                        .font(.redeemTitle)
                    Spacer()
                    Image("ic-heart")
                }
                Text("Use points to purchase these items")
                    .font(.redeemText)
                    .lineSpacing(2)
                Spacer()
                Text("100 Points")
                    .font(.redeemTitle)
            }
            .padding(.all, 6)
            Spacer()
        }
        .frame(width: 165, height: 203)
        .background(Color.white)
        .cornerRadius(5)
    }
}

struct RedeemCardView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemCardView()
            .previewLayout(.sizeThatFits)
    }
}
