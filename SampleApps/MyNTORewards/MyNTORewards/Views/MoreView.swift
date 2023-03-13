//
//  MoreView.swift
//  MyNTORewards
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
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var benefitVM: BenefitViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @EnvironmentObject private var imageVM: ImageViewModel

    
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
            NavigationView {
                List {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("img-profile-adam")
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
                    }

                    Button {
                        rootVM.signOutUser()
                    } label: {
                        Label("Log Out", image: "ic-logout")
                            .font(.menuText)
                            .foregroundColor(Color.theme.accent)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .frame(height: 72)
                    .onReceive(rootVM.$userState) { state in
                        if state == UserState.signedOut {
                            appViewRouter.signedIn = false
                            appViewRouter.currentPage = .onboardingPage
                            
                            benefitVM.clear()
                            profileVM.clear()
                            promotionVM.clear()
                            transactionVM.clear()
                            voucherVM.clear()
                            imageVM.clear()
                        }
                    }
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
