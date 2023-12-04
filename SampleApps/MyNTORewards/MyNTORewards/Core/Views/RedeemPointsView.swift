//
//  RedeemPointsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/8/22.
//

import SwiftUI

struct RedeemPointsView: View {
    var body: some View {
        
        ViewAllView(title: "Redeem Points") {
            AllRedeemPointsView()
        } content: {
            HStack {
                Spacer()
                RedeemCardView()
                Spacer()
                RedeemCardView2()
                Spacer()
            }
        }
        .frame(height: 400)
    }
}

struct RedeemPointsView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemPointsView()
    }
}
