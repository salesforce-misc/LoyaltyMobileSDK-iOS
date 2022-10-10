//
//  RewardsView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct OffersView: View {
    
    @State var offerTabSelected: Int = 0
    let barItems = ["All", "Active", "Expiring Soon"]
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {

                VStack(spacing: 15) {
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                    MyOffersCardView()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 110)

            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Offers")
                        .font(.congratsTitle)
                        .padding(.leading, 15)
                    Spacer()
                    Image("ic-search")
                        .padding(.trailing, 15)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                TopTabBar(barItems: barItems, tabIndex: $offerTabSelected)
                Spacer()
            }
            
        }
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        OffersView()
        //TabBarButton(text: "All", isSelected: .constant(true))
        //TopTabBar(tabIndex: .constant(2))
    }
}
