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
    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var rootVM = AppRootViewModel()
	@State var selectedTab: Int = Tab.home.rawValue
	
	var body: some View {
        ZStack(alignment: .bottomLeading) {
            TabView(selection: tabSelection()) {
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
	}
}
extension BottomNavTabsView {
    
    private func tabSelection() -> Binding<Int> {
        Binding { //this is the get block
            self.selectedTab
        } set: { tappedTab in
            if tappedTab == self.selectedTab {
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
            }
            //Set the tab to the tabbed tab
            self.selectedTab = tappedTab
        }
    }
}

struct BottomNavTabsView_Previews: PreviewProvider {
	static var previews: some View {
		BottomNavTabsView()
			.environmentObject(dev.rootVM)
	}
}
