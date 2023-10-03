//
//  MyNTORewardsApp.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

@main
struct MyNTORewardsApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var appRootVM = AppRootViewModel()
    @StateObject var benefitVM = BenefitViewModel()
	@StateObject var profileVM = ProfileViewModel()
    @StateObject var imageVM = ImageViewModel()
    @StateObject var connectedAppVM = ConnectedAppsViewModel<ForceConnectedAppKeychainManager>()
    @StateObject var processedReceiptVM = ProcessedReceiptViewModel()
    @StateObject var localeManager = LocaleManager()
    
    init() {
        _ = AppSettings.shared
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appViewRouter)
                .environmentObject(appRootVM)
                .environmentObject(benefitVM)
				.environmentObject(profileVM)
                .environmentObject(imageVM)
                .environmentObject(connectedAppVM)
                .environmentObject(processedReceiptVM)
                .environmentObject(localeManager)
        }
    }
}
