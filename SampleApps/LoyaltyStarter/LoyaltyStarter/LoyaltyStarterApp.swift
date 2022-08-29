//
//  LoyaltyStarterApp.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase
import SwiftlySalesforce


@main
struct LoyaltyStarterApp: App {

    @StateObject var appViewRouter = AppViewRouter()
    @StateObject var salesforce: Connection = try! Salesforce.connect()

    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appViewRouter)
                .environmentObject(salesforce)
        }
    }
}
