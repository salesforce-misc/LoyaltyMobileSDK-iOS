//
//  ContentView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct BottomNavTabsView: View {
    @Environment(\.scenePhase) var scenePhase
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
            
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("AppStatus:Active")
                //whenever app return to the foreground or be active. try to see if auth token is available, if not, relogin to get accessToken.
                Task {
                    if(ForceAuthManager.shared.getAuth() == nil){
                        try await ForceAuthManager.shared.grantAuth()
                    }
                }
            } else if newPhase == .inactive {
                // app probably only inactive for a little bit, assumption: no need to clear accessToken.
                print("AppStatus:Inactive")
            } else if newPhase == .background {
                print("AppStatus:Background")
                // app went to background, most likely the session will expired after a period of time. Need to re-login to get accessToken.
                ForceAuthManager.shared.clearAuth()
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavTabsView()
    }
}
