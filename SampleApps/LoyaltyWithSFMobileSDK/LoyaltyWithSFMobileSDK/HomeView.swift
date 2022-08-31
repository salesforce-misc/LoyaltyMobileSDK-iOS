//
//  HomeView.swift
//  LoyaltyWithSFMobileSDK
//
//  Created by Leon Qi on 8/30/22.
//  Copyright © 2022 LoyaltyWithSFMobileSDKOrganizationName. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    
    @State var signOutProcessing = false
    
    var body: some View {
                       
        NavigationView {
            let user = Auth.auth().currentUser
            let welcomeMessage = "Welcome \(user?.email ?? "")"
            
            Text("Home View")
                .navigationTitle(welcomeMessage)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if signOutProcessing {
                            ProgressView()
                        } else {
                            Button("Sign Out") {
                                signOutUser()
                            }
                        }
                    }
                }
        }
    }
        
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")

            signOutProcessing = false
        }
        appViewRouter.currentPage = .signInPage
        appViewRouter.signedIn = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
