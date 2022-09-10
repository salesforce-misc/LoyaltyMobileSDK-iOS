//
//  MoreView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/6/22.
//

import SwiftUI

struct MenuItem: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var title: String
}

struct MoreView: View {
    
    let menuItems: [MenuItem] = [
        MenuItem(icon: "ic-person", title: "Personal Information"),
        MenuItem(icon: "ic-address", title: "Address"),
        MenuItem(icon: "ic-card", title: "Payment Methods"),
        MenuItem(icon: "ic-orders", title: "Orders"),
        MenuItem(icon: "ic-benefits", title: "Benefits"),
        MenuItem(icon: "ic-case", title: "Case Tickets"),
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
                        // TODO: Logout
                    } label: {
                        Label("Logout", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 65)
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
                
            }
        }

    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
