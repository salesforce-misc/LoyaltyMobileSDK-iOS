//
//  MoreView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/6/22.
//

import SwiftUI

struct MenuItem: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var title: String
    var accessibilityIdentifier: String
}

struct MoreView: View {
    
//    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var rootVM: AppRootViewModel
//    @EnvironmentObject private var benefitVM: BenefitViewModel
//    @EnvironmentObject private var profileVM: ProfileViewModel
//    @EnvironmentObject private var promotionVM: PromotionViewModel
//    @EnvironmentObject private var transactionVM: TransactionViewModel
//    @EnvironmentObject private var voucherVM: VoucherViewModel
//    @EnvironmentObject private var imageVM: ImageViewModel
    
    let menuItems: [MenuItem] = [
        MenuItem(icon: "ic-person", title: "Account", accessibilityIdentifier: AppAccessibilty.More.account),
        MenuItem(icon: "ic-address", title: "Addresses", accessibilityIdentifier: AppAccessibilty.More.address),
        MenuItem(icon: "ic-card", title: "Payment Methods", accessibilityIdentifier: AppAccessibilty.More.paymentMethod),
        MenuItem(icon: "ic-orders", title: "Orders", accessibilityIdentifier: AppAccessibilty.More.orders),
        MenuItem(icon: "ic-case", title: "Support", accessibilityIdentifier: AppAccessibilty.More.support),
        MenuItem(icon: "ic-heart", title: "Favorites", accessibilityIdentifier: AppAccessibilty.More.favourites)
    ]
    var body: some View {
        VStack {
            NavigationView {
                List {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("img-profile-adam")
                                .accessibilityIdentifier(AppAccessibilty.More.profileImage)
                            Spacer()
                        }

                        Text("\(rootVM.member?.firstName.capitalized ?? "") \(rootVM.member?.lastName.capitalized ?? "")")
                            .font(.nameText)
                    }
                    .listRowSeparator(.hidden, edges: .top)
                    .frame(height: 85)
                    
                    ForEach(menuItems) { menu in
						Label(menu.title, image: menu.icon)
							.font(.menuText)
							.frame(height: 65)
							.listRowSeparatorTint(Color.theme.listSeparatorPink)
                            .accessibilityIdentifier(menu.accessibilityIdentifier)
                    }

                    Button {
                        rootVM.signOutUser()
                    } label: {
                        Label("Log Out", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .accessibilityIdentifier(AppAccessibilty.More.logout)
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 72)
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
                
            }
            .navigationViewStyle(.stack)
            
            if rootVM.isInProgress {
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
