//
//  HomeView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    var body: some View {
                       
        NavigationView {
            let user = Auth.auth().currentUser
            let welcomeMessage = "Welcome \(user?.email ?? "")"
            
            Text("HomeView")
                .navigationTitle(welcomeMessage)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

