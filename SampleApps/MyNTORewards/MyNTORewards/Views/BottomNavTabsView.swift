//
//  BottomNavTabsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/22.
//

import SwiftUI

struct BottomNavTabsView: View {
	@StateObject var promotionsVM = PromotionViewModel()
	@StateObject var vouchersVM = VoucherViewModel()
	@StateObject var profileVM = ProfileViewModel()
	@StateObject var transactionVM = TransactionViewModel()
	@StateObject var cameraVM = CameraViewModel()
	@StateObject var routerPath = RouterPath()
	@StateObject var receiptListViewModel = ReceiptListViewModel()
	@State var selectedTab: Int = Tab.home.rawValue
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .bottomLeading) {
                TabView(selection: $selectedTab) {
                    HomeView(selectedTab: $selectedTab).tabItem({
                        Label("Home", image: "ic-home")
                    }).tag(Tab.home.rawValue)
                    					
					MyPromotionsView()
						.tabItem({
                            Label("My Promotions", image: "ic-rewards")

                        }).tag(Tab.offers.rawValue)
					ProfileView()
						.tabItem({
                            Label("My Profile", image: "ic-profile")
                        }).tag(Tab.profile.rawValue)

					/* Post MVP
					 RedeemView()
					 .tabItem("Redeem", image: UIImage(named: "ic-book"))
					 */
					
					MoreView()
						.tabItem({
                            Label("More", image: "ic-more")
                        }).tag(Tab.more.rawValue)

				}
				.onChange(of: selectedTab) { _ in
					routerPath.pathFromHome.removeAll()
					routerPath.pathFromMore.removeAll()
				}
			}
			.background {
				LoyaltyConditionalNavLink(isActive: $promotionsVM.isCheckoutNavigationActive) {
					ProductView()
				} label: {
					EmptyView()
				}
			}
            .navigationBarHidden(true)
			.onAppear {
				// correct the transparency bug for Tab bars
				let tabBarAppearance = UITabBarAppearance()
				tabBarAppearance.configureWithOpaqueBackground()
				UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
				// correct the transparency bug for Navigation bars
				let navigationBarAppearance = UINavigationBarAppearance()
				navigationBarAppearance.configureWithOpaqueBackground()
				UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
			} // To Fix Tab bar at the bottom of an app goes transparent when navigating back from another view
		}
		.withSheetDestination(sheetDestination: $routerPath.presentedSheet)
        .environmentObject(promotionsVM)
        .environmentObject(vouchersVM)
        .environmentObject(profileVM)
        .environmentObject(transactionVM)
        .environmentObject(cameraVM)
        .environmentObject(routerPath)
        .environmentObject(receiptListViewModel)
        .navigationViewStyle(.stack)
	}
}

struct BottomNavTabsView_Previews: PreviewProvider {
	static var previews: some View {
		BottomNavTabsView()
			.environmentObject(dev.rootVM)
	}
}
