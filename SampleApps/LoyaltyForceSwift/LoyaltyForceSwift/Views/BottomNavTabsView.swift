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
                HomeView(selectedTab: $selectedTab)
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
                        Text("My Promotions")
                    }
                    .tag(Tab.offers)
                
                ProfileView()
                    .tabItem {
                        Image("ic-profile")
                            .renderingMode(.template)
                        Text("My Profile")
                    }
                    .tag(Tab.profile)
                
                /* Post MVP
                RedeemView()
                    .tabItem {
                        Image("ic-book")
                            .renderingMode(.template)
                        Text("Redeem")
                    }
                    .tag(Tab.redeem)
                */
                MoreView()
                    .tabItem {
                        Image("ic-more")
                            .renderingMode(.template)
                        Text("More")
                    }
                    .tag(Tab.more)
                
            }
            .onAppear {
                // correct the transparency bug for Tab bars
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                // correct the transparency bug for Navigation bars
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            } // To Fix Tab bar at the bottom of an app goes transparent when navigating back from another view
            
        }
        
    }
}

struct BottomNavTabsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavTabsView()
            .environmentObject(dev.rootVM)
    }
}
