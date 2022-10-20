//
//  ContentView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct BottomNavTabsView: View {

    @State var selectedTab: Tab = .home
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image("ic-home")
                            .renderingMode(.template)
                        Text("Home")
                    }
                    .tag(Tab.home)
                
                OffersView()
                    .tabItem {
                        Image("ic-rewards")
                            .renderingMode(.template)
                        Text("Offers")
                    }
                    .tag(Tab.offers)
                
                ProfileView()
                    .tabItem {
                        Image("ic-profile")
                            .renderingMode(.template)
                        Text("Profile")
                    }
                    .tag(Tab.profile)
                
                RedeemView()
                    .tabItem {
                        Image("ic-book")
                            .renderingMode(.template)
                        Text("Redeem")
                    }
                    .tag(Tab.redeem)
                
                MoreView()
                    .tabItem {
                        Image("ic-more")
                            .renderingMode(.template)
                        Text("More")
                    }
                    .tag(Tab.more)
                
            }
            
        }
        
    }
}

struct BottomNavTabsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavTabsView()
    }
}
