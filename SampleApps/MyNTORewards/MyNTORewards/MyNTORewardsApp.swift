//
//  MyNTORewardsApp.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK

@main
struct MyNTORewardsApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var appRootVM = AppRootViewModel()
    @StateObject var benefitVM = BenefitViewModel()
	@StateObject var profileVM = ProfileViewModel()
    @StateObject var imageVM = ImageViewModel()
    @StateObject var connectedAppVM = ConnectedAppsViewModel<ForceConnectedAppKeychainManager>()
    
    init() {
        _ = AppSettings.shared

        // delete all cached data to force reload data from server
        // in case of reinit after app cold relaunch, crashes, updates, reboot or terminated in background
        let folders = [AppSettings.cacheFolders.benefits,
                       AppSettings.cacheFolders.images,
                       AppSettings.cacheFolders.promotions,
                       AppSettings.cacheFolders.transactions,
                       AppSettings.cacheFolders.vouchers]
        LocalFileManager.instance.removeDataFolders(folderNames: folders)
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
        }
    }
}
