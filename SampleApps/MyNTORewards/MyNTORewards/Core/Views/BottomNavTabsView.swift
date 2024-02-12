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
	@EnvironmentObject var appViewRouter: AppViewRouter
    @StateObject var rootVM = AppRootViewModel()
	@StateObject var gameZoneVM: GameZoneViewModel
	@StateObject var referralVM: ReferralViewModel
	@State var selectedTab: Int
	
	init(selectedTab: Int = Tab.home.rawValue) {
		_selectedTab = State(wrappedValue: selectedTab)
		#if DEBUG
		if UITestingHelper.isUITesting {
            _gameZoneVM = StateObject(wrappedValue: GameZoneViewModel(devMode: true,
                                                                                  mockFileName: UITestingHelper.getGamesMockFileName
                                                                                 ))
			_referralVM = StateObject(wrappedValue: ReferralViewModel(devMode: true, isEnrolled: UITestingHelper.isUserEnrolledForReferral))
        } else {
			_gameZoneVM = StateObject(wrappedValue: GameZoneViewModel())
			_referralVM = StateObject(wrappedValue: ReferralViewModel())
		}
		#else
			_gameZoneVM = StateObject(wrappedValue: GameZoneViewModel())
			_referralVM = StateObject(wrappedValue: ReferralViewModel())
		#endif
	}
	
	var body: some View {
        ZStack(alignment: .bottomLeading) {
            TabView(selection: tabSelection()) {
				HomeView(selectedTab: $appViewRouter.selectedTab).tabItem({
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
			.onChange(of: appViewRouter.selectedTab) { _ in
                routerPath.pathFromHome.removeAll()
                routerPath.pathFromMore.removeAll()
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
        .onChange(of: appViewRouter.isAuthenticated, perform: { newValue in
            if !newValue && rootVM.userState == .signedIn {
                rootVM.signOutUser()
            }
        })
		.withSheetDestination(sheetDestination: $routerPath.presentedSheet)
        .environmentObject(promotionsVM)
        .environmentObject(vouchersVM)
        .environmentObject(profileVM)
        .environmentObject(transactionVM)
        .environmentObject(cameraVM)
        .environmentObject(routerPath)
        .environmentObject(receiptListViewModel)
        .environmentObject(gameZoneVM)
        .environmentObject(referralVM)
	}
}

extension BottomNavTabsView {
	
	private func tabSelection() -> Binding<Int> {
		Binding { //this is the get block
			appViewRouter.selectedTab
		} set: { tappedTab in
			if tappedTab == appViewRouter.selectedTab {
				//User tapped on the tab twice == Pop to root view for Home tab
				if routerPath.pathFromHome.isEmpty {
					//User already on home view, scroll to top
				} else {
					routerPath.pathFromHome = []
				}
				//User tapped on the tab twice == Pop to root view for More tab
				if routerPath.pathFromMore.isEmpty {
					//User already on home view, scroll to top
				} else {
					routerPath.pathFromMore = []
				}
                //User tapped on the tab twice == Pop to root view for More tab
                if routerPath.pathFromPromotion.isEmpty {
                    //User already on home view, scroll to top
                } else {
                    routerPath.pathFromPromotion = []
                }
			}
			//Set the tab to the tabbed tab
			appViewRouter.selectedTab = tappedTab
		}
	}
}

struct BottomNavTabsView_Previews: PreviewProvider {
	static var previews: some View {
		BottomNavTabsView()
			.environmentObject(dev.rootVM)
            .environmentObject(AppViewRouter())
	}
}
