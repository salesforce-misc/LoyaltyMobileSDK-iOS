//
//  AppViewRouter.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK
import Combine

// recommend MainActor in ObservableObject class
// https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-mainactor-to-run-code-on-the-main-queue

@MainActor
class AppViewRouter: ObservableObject {
    // used for routing to different top views.
    @Published var currentPage: Page = .onboardingPage
    // used for managing the signIn state.
    @Published var signedIn = false
    // check if the user is authenticated
    @Published var isAuthenticated: Bool = ForceAuthManager.shared.getAuth() != nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        ForceAuthManager.shared.$auth
            .receive(on: DispatchQueue.main)
            .map { _ in ForceAuthManager.shared.getAuth() != nil }
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
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
