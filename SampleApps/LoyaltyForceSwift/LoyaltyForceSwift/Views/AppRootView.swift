//
//  MotherView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct AppRootView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    
    var body: some View {
               
        Group {
            if appViewRouter.signedIn {
                BottomNavTabsView()
            } else {
                switch appViewRouter.currentPage {
                case .signUpPage:
                    SignUpView()
                case .signInPage:
                    SignInView()
                case .homePage:
                    BottomNavTabsView()
                case .onboardingPage:
                    OnboardingView()
                case .signInPageFromSignUp:
                    OnboardingView(signUpPresented: false, signInPresented: true)
                case .signUpPageFromSignIn:
                    OnboardingView(signUpPresented: true, signInPresented: false)
                }
            }
        }
        .onAppear() {
            appViewRouter.signedIn = appViewRouter.isSignedIn
        }
    }
}

struct AppStateManagerView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView().environmentObject(AppViewRouter())
    }
}
