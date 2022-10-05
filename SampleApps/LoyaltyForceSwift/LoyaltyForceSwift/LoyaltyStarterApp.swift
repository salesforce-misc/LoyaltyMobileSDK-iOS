//
//  LoyaltyStarterApp.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase


@main
struct LoyaltyStarterApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var onboardingVM = OnboardingViewModel()

    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appViewRouter)
                .environmentObject(onboardingVM)
        }
    }
}
