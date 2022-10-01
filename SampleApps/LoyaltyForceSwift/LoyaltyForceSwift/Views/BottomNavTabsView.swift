//
//  ContentView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct BottomNavTabsView: View {

    @State private var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image("ic-home")
                            .renderingMode(.template)
                        Text("Home")
                    }
                    .tag(0)
                
                RewardsView()
                    .tabItem {
                        Image("ic-rewards")
                            .renderingMode(.template)
                        Text("Offers")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image("ic-profile")
                            .renderingMode(.template)
                        Text("Profile")
                    }
                    .tag(2)
                
                RedeemView()
                    .tabItem {
                        Image("ic-book")
                            .renderingMode(.template)
                        Text("Redeem")
                    }
                    .tag(3)
                
                MoreView()
                    .tabItem {
                        Image("ic-more")
                            .renderingMode(.template)
                        Text("More")
                    }
                    .tag(4)
                
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavTabsView()
    }
}
