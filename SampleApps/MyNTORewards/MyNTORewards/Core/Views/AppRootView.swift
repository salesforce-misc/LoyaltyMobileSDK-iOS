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
	@EnvironmentObject private var benefitVM: BenefitViewModel
	@EnvironmentObject private var profileVM: ProfileViewModel
	@EnvironmentObject private var imageVM: ImageViewModel
	
	var body: some View {
		Group {
			if appViewRouter.signedIn {
				BottomNavTabsView()
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
			appViewRouter.signedIn = appViewRouter.isAuthenticated
			if appViewRouter.isAuthenticated && rootVM.member == nil {
				rootVM.member = LocalFileManager.instance.getData(type: CommunityMemberModel.self, id: rootVM.email)
			}
		}
		.onChange(of: appViewRouter.isAuthenticated, perform: { newValue in
			if !newValue && rootVM.userState == .signedIn {
				rootVM.signOutUser()
			}
		})
		.onChange(of: appViewRouter.currentPage, perform: { _ in
			switch appViewRouter.currentPage {
			case .navTabsPage(selectedTab: Tab.home.rawValue):
				appViewRouter.selectedTab = Tab.home.rawValue
			case .navTabsPage(selectedTab: Tab.offers.rawValue):
				appViewRouter.selectedTab = Tab.offers.rawValue
			case .navTabsPage(selectedTab: Tab.profile.rawValue):
				appViewRouter.selectedTab = Tab.profile.rawValue
			case .navTabsPage(selectedTab: Tab.redeem.rawValue):
				appViewRouter.selectedTab = Tab.redeem.rawValue
			case .navTabsPage(selectedTab: Tab.more.rawValue):
				appViewRouter.selectedTab = Tab.more.rawValue
			default:
				appViewRouter.selectedTab = Tab.home.rawValue
			}
		})
		.onOpenURL { url in
			Logger.debug(url.absoluteString)
			redirectDeeplink(url: url)
		}
		.onReceive(rootVM.$userState) { state in
			if state == UserState.signedOut {
				appViewRouter.signedIn = false
				appViewRouter.currentPage = .onboardingPage
				
				benefitVM.clear()
				profileVM.clear()
				imageVM.clear()
			}
		}
	}
	
	/// Sample reset password email link:
	/// loyaltyapp://resetpassword?mode=resetPassword&oobCode=YOUR_CODE&apiKey=YOUR_KEY&lang=en
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
