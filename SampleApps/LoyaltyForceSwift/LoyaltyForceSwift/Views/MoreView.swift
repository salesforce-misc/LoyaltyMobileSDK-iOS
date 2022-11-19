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
        MenuItem(icon: "ic-person", title: "Account"),
        MenuItem(icon: "ic-address", title: "Addresses"),
        MenuItem(icon: "ic-card", title: "Payment Methods"),
        MenuItem(icon: "ic-orders", title: "Orders"),
        //MenuItem(icon: "ic-benefits", title: "Benefits"),
        MenuItem(icon: "ic-case", title: "Support"),
        MenuItem(icon: "ic-heart", title: "Favorites")
    ]
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image("img-profile")
                    Spacer()
                }
                
                Text("\(viewModel.member?.firstName.capitalized ?? "") \(viewModel.member?.lastName.capitalized ?? "")")
                    .font(.nameText)
            }
            .frame(height: 85)
            .padding(.horizontal)

            NavigationView {
                List {
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
                        Label("Log Out", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 72)
                    .onReceive(viewModel.$userState) { state in
                        if state == UserState.signedOut {
                            appViewRouter.signedIn = false
                            appViewRouter.currentPage = .onboardingPage
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
                
            }
            .navigationViewStyle(.stack)
            
            if viewModel.isInProgress {
                ProgressView()
            }
        }

    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
            .environmentObject(dev.rootVM)
    }
}
