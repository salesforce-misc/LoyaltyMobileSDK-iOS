//
//  RewardsView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct MyPromotionsView: View {
    
    @State var offerTabSelected: Int = 0
    let barItems = ["Unenrolled", "Active", "All"]
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            TabView(selection: $offerTabSelected) {
                ForEach(0..<barItems.count, id: \.self) { index in
                    
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            MyOffersCardView()
                            MyOffersCardView1()
                            MyOffersCardView2()
                            MyOffersCardView3()
                            MyOffersCardView4()
                            MyOffersCardView5()
                            MyOffersCardView3()
                            MyOffersCardView5()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 110)
                        
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Promotions")
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

struct MyPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPromotionsView()
    }
}
