//
//  HomeView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    
    @State var signOutProcessing = false
    
    var body: some View {
                       
        Group {
            let user = Auth.auth().currentUser
            let welcomeMessage = "Welcome \(user?.email ?? "")"
            
            Text("HomeView")
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
//            print("Error signing out: %@", signOutError)
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

