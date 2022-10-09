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
    @EnvironmentObject var viewModel: AppRootViewModel
    
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
                        viewModel.signOutUser()
                    } label: {
                        Label("Logout", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 72)
                    .onReceive(viewModel.$userState) { state in
                        if state == UserState.signout {
                            appViewRouter.signedIn = false
                            appViewRouter.currentPage = .onboardingPage
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
                
            }
            if viewModel.isInProgress {
                ProgressView()
            }
        }

    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
