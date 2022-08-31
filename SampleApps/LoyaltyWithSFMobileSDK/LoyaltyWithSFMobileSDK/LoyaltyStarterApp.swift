//
//  LoyaltyStarterApp.swift
//  LoyaltyWithSFMobileSDK
//
//  Created by Leon Qi on 8/30/22.
//  Copyright © 2022 LoyaltyWithSFMobileSDKOrganizationName. All rights reserved.
//

import SwiftUI

struct LoyaltyStarterApp: View {

    @StateObject var appViewRouter = AppViewRouter()

    var body: some View {
        AppRootView()
            .environmentObject(appViewRouter)

    }
}
