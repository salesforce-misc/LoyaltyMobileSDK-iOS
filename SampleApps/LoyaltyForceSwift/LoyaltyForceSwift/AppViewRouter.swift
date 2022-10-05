//
//  ViewRouter.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

class AppViewRouter: ObservableObject {
    // used for routing to different top views.
    @Published var currentPage: Page = .onboardingPage
    // used for managing the signIn state.
    @Published var signedIn = false
    
    // check if the user is signedin already when app starts.
    private let auth = Auth.auth()
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    enum deeplinkHosts: String {
        case resetPassword = "resetpassword"
    }
}

enum Page: Hashable {
    case onboardingPage
    case createNewPasswordPage
    case navTabsPage(selectedTab: Tab)
}

enum Tab: Hashable {
    case home
    case offers
    case profile
    case redeem
    case more
}
