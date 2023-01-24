//
//  MyNTORewardsApp.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase


@main
struct MyNTORewardsApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var appRootVM = AppRootViewModel()
    @StateObject var benefitVM = BenefitViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var promotionVM = PromotionViewModel()
    @StateObject var transactionVM = TransactionViewModel()
    @StateObject var voucherVM = VoucherViewModel()
    @StateObject var imageVM = ImageViewModel()

    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appViewRouter)
                .environmentObject(appRootVM)
                .environmentObject(benefitVM)
                .environmentObject(profileVM)
                .environmentObject(promotionVM)
                .environmentObject(transactionVM)
                .environmentObject(voucherVM)
                .environmentObject(imageVM)
        }
    }
}
