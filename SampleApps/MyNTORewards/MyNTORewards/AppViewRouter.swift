//
//  AppViewRouter.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK

// recommend MainActor in ObservableObject class
// https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-mainactor-to-run-code-on-the-main-queue

@MainActor
class AppViewRouter: ObservableObject {
    // used for routing to different top views.
    @Published var currentPage: Page = .onboardingPage
    // used for managing the signIn state.
    @Published var signedIn = false
    
    // check if the user is signedin already when app starts.
    private let auth = ForceAuthManager.shared.getAuth()
    var isSignedIn: Bool {
        return auth != nil
    }
    
    enum DeeplinkHosts: String {
        case resetPassword = "resetpassword"
    }
}

enum Page: Hashable {
    case onboardingPage
    case createNewPasswordPage
    case navTabsPage(selectedTab: Int = 0)
}

enum Tab: Int {
    case home
    case offers
    case profile
    case redeem
    case more
}
