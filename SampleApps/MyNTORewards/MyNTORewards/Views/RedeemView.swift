//
//  RedeemView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct RedeemView: View {
    
    var body: some View {
        ZStack {
            Color.theme.background
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        RedeemCardView()
                        RedeemCardView2()
                    }
                    
//                    MyOffersCardView2()
//                    MyOffersCardView3()
//                    MyOffersCardView4()
//                    MyOffersCardView5()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 110)
                
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Redeem")
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                    Spacer()
                    Image("ic-search")
                        .padding(.trailing, 15)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                HStack {
                    Text("4300 Points")
                        .foregroundColor(Color.theme.accent)
                        .font(.pointsText)
                        .padding(.leading, 15)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                Spacer()
            }
            
        }
    }
}

struct RedeemView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemView()
    }
}
