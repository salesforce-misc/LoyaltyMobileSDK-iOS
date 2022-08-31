//
//  AppRootView.swift
//  LoyaltyWithSFMobileSDK
//
//  Created by Leon Qi on 8/30/22.
//  Copyright © 2022 LoyaltyWithSFMobileSDKOrganizationName. All rights reserved.
//

import SwiftUI
import Firebase

struct AppRootView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    
    var body: some View {
               
        Group {
            if appViewRouter.signedIn {
                BottomNavTabsView()
            }else{
                switch appViewRouter.currentPage {
                case .signUpPage:
                    SignUpView()
                case .signInPage:
                    SignInView()
                case .homePage:
                    BottomNavTabsView()
                }
            }
        }
        .onAppear(){
            appViewRouter.signedIn = appViewRouter.isSignedIn
        }
    }
}

struct AppStateManagerView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView().environmentObject(AppViewRouter())
    }
}

