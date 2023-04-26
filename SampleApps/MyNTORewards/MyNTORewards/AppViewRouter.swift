//
//  AppViewRouter.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase
import LoyaltyMobileSDK

// recommend MainActor in ObservableObject class
// https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-mainactor-to-run-code-on-the-main-queue

@MainActor
class AppViewRouter: ObservableObject {
    // used for routing to different top views.
    @Published var currentPage: Page = .onboardingPage
    // used for managing the signIn state.
    @Published var signedIn = false
    
    init() {
        signOutIfNeeded()
    }
    
    // this is deal with Firebase Auth saved to keychain and will retain logged in even delete/reinstall the app
    func signOutIfNeeded() {
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeLauched") == nil {
            // if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeLauched")
            // signOut from FIRAuth
            do {
                try Auth.auth().signOut()
            } catch {
                Logger.error("<Firebase> - Error signing out: \(error)")
            }
        }
    }
    
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
