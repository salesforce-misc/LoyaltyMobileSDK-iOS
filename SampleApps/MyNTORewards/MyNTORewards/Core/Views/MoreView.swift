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
    @StateObject private var loyaltyFeatureManager = LoyaltyFeatureManager.shared
    @State private var menuItems: [MenuItem] = [
//        MenuItem(icon: "ic-person", title: "Account", accessibilityIdentifier: AppAccessibilty.More.account),
//        MenuItem(icon: "ic-address", title: "Addresses", accessibilityIdentifier: AppAccessibilty.More.address),
//        MenuItem(icon: "ic-card", title: "Payment Methods", accessibilityIdentifier: AppAccessibilty.More.paymentMethod),
//        MenuItem(icon: "ic-orders", title: "Orders", accessibilityIdentifier: AppAccessibilty.More.orders),
		MenuItem(icon: "ic-receipts", title: "Receipts", accessibilityIdentifier: AppAccessibilty.More.receipts),
        MenuItem(icon: "ic-game", title: "Game Zone", accessibilityIdentifier: AppAccessibilty.More.game),
//        MenuItem(icon: "ic-case", title: "Support", accessibilityIdentifier: AppAccessibilty.More.support),
//        MenuItem(icon: "ic-heart", title: "Favorites", accessibilityIdentifier: AppAccessibilty.More.favourites)
    ]
    var body: some View {
        VStack {
			NavigationStack(path: $routerPath.pathFromMore) {
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
                                routerPath.navigateFromMore(to: .receipts)
                            case "Game Zone":
                                routerPath.navigateFromMore(to: .gameZone)
                            case "My Referrals":
                                routerPath.navigateFromMore(to: .referrals)
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
				.onAppear {
					if routerPath.startWithGameZoneInMore {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							routerPath.startWithGameZoneInMore = false
							routerPath.navigateFromMore(to: .gameZone)
						}
					}
                    addReferralsMenu()
				}
                .listStyle(.plain)
                .navigationBarHidden(true)
				.withAppRouter()
				.environmentObject(rootVM)
            }.onChange(of: LoyaltyFeatureManager.shared.isReferralFeatureEnabled, perform: { _ in 
                addReferralsMenu()
            })
			.environmentObject(routerPath)
            
            if rootVM.isInProgress {
                ProgressView()
            }
        }
    }
    
    func addReferralsMenu() {
            if LoyaltyFeatureManager.shared.isReferralFeatureEnabled {
                if !menuItems.contains(where: {$0.icon == "ic-groups" && $0.title == "My Referrals"}) {
                    menuItems.append(MenuItem(icon: "ic-groups", title: "My Referrals", accessibilityIdentifier: AppAccessibilty.More.referrals))
            }
            } else {
                menuItems.removeAll(where: {$0.icon == "ic-groups" && $0.title == "My Referrals"})
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
