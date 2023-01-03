//
//  LoyaltyNavBarContainerView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct LoyaltyNavBarContainerView<Content: View>: View {
    
    let content: Content
    @State private var showSearchButton: Bool = true
    @State private var title: String = ""
    @State private var tabBar: TopTabBar? = nil

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            LoyaltyNavBarView(showSearchButton: showSearchButton, title: title, tabBar: tabBar)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(LoyaltyNavBarTitlePreferenceKey.self, perform: { value in
            self.title = value
        })
        .onPreferenceChange(LoyaltyNavBarSearchButtonHiddenPreferenceKey.self, perform: { value in
            self.showSearchButton = !value
        })
        .onPreferenceChange(LoyaltyNavBarTabBarPreferenceKey.self, perform: { value in
            self.tabBar = value
        })
    }
}

struct LoyaltyNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyNavBarContainerView {
            Color.blue
        }
    }
}
