//
//  LoyaltyStarterApp.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase


@main
struct LoyaltyStarterApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var appRootVM = AppRootViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var promotionVM = PromotionViewModel()
    @StateObject var transactionVM = TransactionViewModel()
    @StateObject var voucherVM = VoucherViewModel()

    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appViewRouter)
                .environmentObject(appRootVM)
                .environmentObject(profileVM)
                .environmentObject(promotionVM)
                .environmentObject(transactionVM)
                .environmentObject(voucherVM)
        }
    }
}
