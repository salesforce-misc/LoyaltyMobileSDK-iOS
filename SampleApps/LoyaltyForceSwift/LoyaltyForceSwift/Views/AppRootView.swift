//
//  MotherView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct AppRootView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    var body: some View {
               
        Group {
            if appViewRouter.signedIn {
                switch appViewRouter.currentPage {
                case .navTabsPage(selectedTab: .home):
                    BottomNavTabsView()
                case .navTabsPage(selectedTab: .offers):
                    BottomNavTabsView(selectedTab: .offers)
                case .navTabsPage(selectedTab: .profile):
                    BottomNavTabsView(selectedTab: .profile)
                case .navTabsPage(selectedTab: .redeem):
                    BottomNavTabsView(selectedTab: .redeem)
                case .navTabsPage(selectedTab: .more):
                    BottomNavTabsView(selectedTab: .more)
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
        .onAppear() {
            appViewRouter.signedIn = appViewRouter.isSignedIn
            if appViewRouter.isSignedIn && viewModel.member == nil {
                viewModel.member = LocalFileManager.instance.getData(type: MemberModel.self, id: viewModel.email)
            }
        }
        .onOpenURL { url in
            print(url)
            redirectDeeplink(url: url)
        }
    }

    /// Sample reset password email link:
    /// loyaltyapp://resetpassword?mode=resetPassword&oobCode=BIteQhy4O0-go_XjLjnbaF3C0KLZXPOQjViTajZTx18AAAGDpVgcog&apiKey=AIzaSyC6N0qud6ZeKl_chRjY_JUEi7QTSPbNWz4&lang=en
    func redirectDeeplink(url: URL) {
        
        let defaultPage: Page = appViewRouter.signedIn ? appViewRouter.currentPage : .onboardingPage
        
        guard url.scheme == AppConstants.Config.deeplinkScheme,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            appViewRouter.currentPage = defaultPage
            return
        }
        
        switch components.host {
        case AppViewRouter.deeplinkHosts.resetPassword.rawValue:
            let items = queryItems.reduce(into: [String: String]()) { (result, item) in
                result[item.name] = item.value
            }
                    
            guard let oobCode = items["oobCode"] else {
                appViewRouter.currentPage = defaultPage
                return
            }
            viewModel.oobCode = oobCode
            
            guard let apiKey = items["apiKey"] else {
                appViewRouter.currentPage = defaultPage
                return
            }
            viewModel.apiKey = apiKey
            
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
