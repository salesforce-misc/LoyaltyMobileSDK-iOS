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
            if signOutProcessing {
                ProgressView()
            }
        }

    }
    
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            ForceAuthManager.shared.clearAuth()
            
        } catch {
            print("<Firebase> - Error signing out: \(error.localizedDescription)")
            signOutProcessing = false
        }
        signOutProcessing = false
        appViewRouter.signedIn = false
        appViewRouter.currentPage = .onboardingPage
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
