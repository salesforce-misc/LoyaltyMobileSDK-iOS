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
	@State var showCapturedImage: Bool = false
	@State var capturedImage: UIImage?
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .bottomLeading) {
				UITabView(selection: $selectedTab) {
					HomeView(selectedTab: $selectedTab)
						.tabItem("Home", image: UIImage(named: "ic-home"))
					
					MyPromotionsView()
						.tabItem("My Promotions", image: UIImage(named: "ic-rewards"))
					
					ProfileView()
						.tabItem("My Profile", image: UIImage(named: "ic-profile"))
					/* Post MVP
					 RedeemView()
					 .tabItem("Redeem", image: UIImage(named: "ic-book"))
					 */
					
					MoreView()
						.tabItem("More", image: UIImage(named: "ic-more"))
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
		.fullScreenCover(isPresented: $cameraVM.showCamera) {
			ZStack {
				CameraView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
					.zIndex(showCapturedImage ? 0 : 1)
				if showCapturedImage {
					CapturedImageView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
						.transition(.move(edge: .trailing))
						.zIndex(showCapturedImage ? 1 : 0)
				}
			}
			.animation(.default, value: showCapturedImage)
			.environmentObject(routerPath)
			.environmentObject(receiptListViewModel)
		}
	}
}

struct BottomNavTabsView_Previews: PreviewProvider {
	static var previews: some View {
		BottomNavTabsView()
			.environmentObject(dev.rootVM)
	}
}
