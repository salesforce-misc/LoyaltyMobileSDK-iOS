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
    
    @EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject private var routerPath: RouterPath
    let menuItems: [MenuItem] = [
//        MenuItem(icon: "ic-person", title: "Account", accessibilityIdentifier: AppAccessibilty.More.account),
//        MenuItem(icon: "ic-address", title: "Addresses", accessibilityIdentifier: AppAccessibilty.More.address),
//        MenuItem(icon: "ic-card", title: "Payment Methods", accessibilityIdentifier: AppAccessibilty.More.paymentMethod),
//        MenuItem(icon: "ic-orders", title: "Orders", accessibilityIdentifier: AppAccessibilty.More.orders),
		MenuItem(icon: "ic-receipts", title: "Receipts", accessibilityIdentifier: AppAccessibilty.More.receipts),
        MenuItem(icon: "ic-game", title: "Game Zone", accessibilityIdentifier: AppAccessibilty.More.game)
//        MenuItem(icon: "ic-case", title: "Support", accessibilityIdentifier: AppAccessibilty.More.support),
//        MenuItem(icon: "ic-heart", title: "Favorites", accessibilityIdentifier: AppAccessibilty.More.favourites)
    ]
    var body: some View {
        VStack {
			NavigationStack(path: $routerPath.path) {
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
						Button {
                            switch menu.title {
                            case "Receipts":
                                routerPath.navigate(to: .receipts)
                            case "Game Zone":
                                routerPath.navigate(to: .gameZone)
                            default:
                                break
                            }
						} label: {
							HStack {
								Label(menu.title, image: menu.icon)
									.font(.menuText)
									.frame(height: 65)
									.listRowSeparatorTint(Color.theme.listSeparatorPink)
								.accessibilityIdentifier(menu.accessibilityIdentifier)
								Spacer()
								Image("chevron-right")
							}
						}
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
                    .frame(height: 72)
                    
                    Text("App Version \(Bundle.main.appVersion ?? "") (\(Bundle.main.buildNumber ?? ""))")
                        .listRowSeparator(.hidden, edges: .bottom)
                        .frame(height: 65)
                        .font(.footnote)
                        .foregroundColor(Color.theme.textInactive)
                    
                }
                .listStyle(.plain)
                .navigationBarHidden(true)
				.withAppRouter()
				.withSheetDestination(sheetDestination: $routerPath.presentedSheet)
				.environmentObject(rootVM)
				.environmentObject(routerPath)
            }
            
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
            .environmentObject(dev.routerPath)
    }
}
