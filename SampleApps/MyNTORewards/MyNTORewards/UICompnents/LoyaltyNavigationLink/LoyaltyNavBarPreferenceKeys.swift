//
//  LoyaltyNavBarPreferenceKeys.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/13/22.
//

import Foundation
import SwiftUI

struct LoyaltyNavBarSearchButtonHiddenPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
    
}
struct LoyaltyNavBarTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}

struct LoyaltyNavBarTabBarPreferenceKey: PreferenceKey {
    
    static var defaultValue: TopTabBar?
    
    static func reduce(value: inout TopTabBar?, nextValue: () -> TopTabBar?) {
        value = nextValue()
    }
    
}

extension View {
    
    func loyaltyNavBarSearchButtonHidden(_ hidden: Bool) -> some View {
        preference(key: LoyaltyNavBarSearchButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func loytaltyNavigationTitle(_ title: String) -> some View {
        preference(key: LoyaltyNavBarTitlePreferenceKey.self, value: title)
    }
    
    func loyaltyNavBarTabBar(_ tabBar: TopTabBar?) -> some View {
        preference(key: LoyaltyNavBarTabBarPreferenceKey.self, value: tabBar)
    }
    
    func loyaltyNavBarItems(searchButtonHidden: Bool = false, title: String = "", tabBar: TopTabBar? = nil) -> some View {
        self
            .loyaltyNavBarSearchButtonHidden(searchButtonHidden)
            .loytaltyNavigationTitle(title)
            .loyaltyNavBarTabBar(tabBar)
    }
    
}
