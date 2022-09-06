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
    @Published var currentPage: Page = .signInPage
    // used for managing the signIn state.
    @Published var signedIn = false
    
    // check if the user is signedin already when app starts.
    let auth = Auth.auth()
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
}

enum Page {
    case signUpPage
    case signInPage
    case homePage
}

//struct User {
//    var uid: String
//    var email: String?
//    var displayName: String?
//
//    init(uid: String, email: String?, displayName: String?) {
//        self.uid = uid
//        self.email = email
//        self.displayName = displayName
//    }
//}

