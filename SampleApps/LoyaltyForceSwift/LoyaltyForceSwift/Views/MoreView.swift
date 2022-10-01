//
//  MoreView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/6/22.
//

import SwiftUI
import Firebase

struct MenuItem: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var title: String
}

struct MoreView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    
    @State var signOutProcessing = false
    
    let menuItems: [MenuItem] = [
        MenuItem(icon: "ic-person", title: "Personal Information"),
        MenuItem(icon: "ic-address", title: "Address"),
        //MenuItem(icon: "ic-card", title: "Payment Methods"),
        //MenuItem(icon: "ic-orders", title: "Orders"),
        //MenuItem(icon: "ic-benefits", title: "Benefits"),
        //MenuItem(icon: "ic-case", title: "Case Tickets"),
        MenuItem(icon: "ic-heart", title: "Favorites")
    ]
    var body: some View {
        VStack {
            NavigationView {
                List {
                    MoreHeaderView()
                        .listRowSeparator(.hidden, edges: .top)
                        .frame(height: 85)
                    ForEach(menuItems) { menu in
                        NavigationLink {
                            // TODO: Links to each view
                        } label: {
                            Label(menu.title, image: menu.icon)
                                .font(.menuText)
                                .frame(height: 65)
                        }
                        .listRowSeparatorTint(Color.theme.listSeparatorPink)
                        
                    }
                    if signOutProcessing {
                        ProgressView()
                    }
                    Button {
                        signOutUser()
                    } label: {
                        Label("Logout", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 72)
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
                
            }
        }

    }
    
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            ForceAuthManager.shared.clearAuth()
            
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")

            signOutProcessing = false
        }
        appViewRouter.currentPage = .onboardingPage
        appViewRouter.signedIn = false
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
