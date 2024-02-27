//
//  AllRedeemPointsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct AllRedeemPointsView: View {
    var body: some View {
        
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {
                
                VStack {
                    HStack {
                        Spacer()
                        RedeemCardView()
                        Spacer()
                        RedeemCardView2()
                        Spacer()
                    }
                    .padding(.vertical)

                    HStack {
                        Spacer()
                        RedeemCardView()
                        Spacer()
                        RedeemCardView2()
                        Spacer()
                    }
                    .padding(.vertical)

                    HStack {
                        Spacer()
                        RedeemCardView()
                        Spacer()
                        RedeemCardView2()
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
            }
            
        }
        .loytaltyNavigationTitle("Redeem Points")
    }
}

struct AllRedeemPointsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRedeemPointsView()
    }
}
