//
//  MotherView.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct AppRootView: View {
	
	@EnvironmentObject private var appViewRouter: AppViewRouter
	@EnvironmentObject private var rootVM: AppRootViewModel
	
	var body: some View {
		NavigationView {
			if appViewRouter.signedIn {
				switch appViewRouter.currentPage {
				case .navTabsPage(selectedTab: Tab.home.rawValue):
					BottomNavTabsView(selectedTab: Tab.home.rawValue)
				case .navTabsPage(selectedTab: Tab.offers.rawValue):
					BottomNavTabsView(selectedTab: Tab.offers.rawValue)
				case .navTabsPage(selectedTab: Tab.profile.rawValue):
					BottomNavTabsView(selectedTab: Tab.profile.rawValue)
				case .navTabsPage(selectedTab: Tab.redeem.rawValue):
					BottomNavTabsView(selectedTab: Tab.redeem.rawValue)
				case .navTabsPage(selectedTab: Tab.more.rawValue):
					BottomNavTabsView(selectedTab: Tab.more.rawValue)
				default:
					BottomNavTabsView()
				}
			} else {
				switch appViewRouter.currentPage {
				case .onboardingPage:
					OnboardingView()
				case .createNewPasswordPage:
					OnboardingView(showCreateNewPassword: true)
				default:
					OnboardingView()
				}
			}
		}
		.onAppear {
			appViewRouter.signedIn = appViewRouter.isSignedIn
			if appViewRouter.isSignedIn && rootVM.member == nil {
				rootVM.member = LocalFileManager.instance.getData(type: CommunityMemberModel.self, id: rootVM.email)
			}
		}
		.onOpenURL { url in
			Logger.debug(url.absoluteString)
			redirectDeeplink(url: url)
		}
	}
	
	/// Sample reset password email link:
	/// loyaltyapp://resetpassword?mode=resetPassword&oobCode=BIteQhy4O0-go_XjLjnbaF3C0KLZXPOQjViTajZTx18AAAGDpVgcog&apiKey=AIzaSyC6N0qud6ZeKl_chRjY_JUEi7QTSPbNWz4&lang=en
	func redirectDeeplink(url: URL) {
		
		let defaultPage: Page = appViewRouter.signedIn ? appViewRouter.currentPage : .onboardingPage
		
		guard url.scheme == AppSettings.Defaults.deeplinkScheme,
			  let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
			  let queryItems = components.queryItems else {
			appViewRouter.currentPage = defaultPage
			return
		}
		
		switch components.host {
		case AppViewRouter.DeeplinkHosts.resetPassword.rawValue:
			let items = queryItems.reduce(into: [String: String]()) { (result, item) in
				result[item.name] = item.value
			}
			
			guard let oobCode = items["oobCode"] else {
				appViewRouter.currentPage = defaultPage
				return
			}
			rootVM.oobCode = oobCode
			
			guard let apiKey = items["apiKey"] else {
				appViewRouter.currentPage = defaultPage
				return
			}
			rootVM.apiKey = apiKey
			
			appViewRouter.currentPage = .createNewPasswordPage
		default:
			appViewRouter.currentPage = defaultPage
		}
	}
}

struct AppRootView_Previews: PreviewProvider {
	static var previews: some View {
		AppRootView()
			.environmentObject(AppViewRouter())
			.environmentObject(AppRootViewModel())
	}
}
