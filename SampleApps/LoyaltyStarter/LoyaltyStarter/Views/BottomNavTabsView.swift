//
//  ContentView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct BottomNavTabsView: View {
    
    @State private var selectedTab = 0
    
    private var singleTabWidth = UIScreen.main.bounds.width / 5
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                    Image("ic-home")
                        .renderingMode(.template)
                }
                .tag(0)
                
                RewardsView()
                    .tabItem {
                        Image("ic-rewards")
                            .renderingMode(.template)
                    }
                    .tag(1)
                
                RedeemView()
                    .tabItem {
                        Image("ic-book")
                            .renderingMode(.template)
                    }
                    .tag(2)
                
                FavoriteView()
                    .tabItem {
                        Image("ic-heart")
                            .renderingMode(.template)
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Image("ic-profile")
                            .renderingMode(.template)
                    }
                    .tag(4)
                
            }
            
            Image("ic-dot")
                .offset(x: singleTabWidth * CGFloat(selectedTab))
                .frame(width: singleTabWidth, height: 5)
                .padding(.bottom, 5)
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavTabsView()
    }
}
