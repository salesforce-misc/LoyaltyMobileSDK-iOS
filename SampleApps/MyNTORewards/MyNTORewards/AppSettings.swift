//
//  AppConstants.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import LoyaltyMobileSDK

struct AppSettings {
    
    static let connectedApp = ForceConnectedApp(
        connectedAppName: "Default",
        consumerKey: "3MVG9SemV5D80oBcyrqrDrrcbLgQBxn3kO2L9XD1sPRm315AGmtHcq1dFUMHh6vSotuV1uuZPfw==",
        consumerSecret: "0ADA86BBC47966C01405CA64A6F409AB15BF9F80E9F83A1B098AB6136AEAC434",
        callbackURL: "https://hutl.my.site.com/oauth2/callback",
        baseURL: "https://login.salesforce.com",
        instanceURL: "https://hutl.my.salesforce.com",
        communityURL: "https://hutl.my.site.com"
    )

    struct Defaults {
        static let loyaltyProgramName = "NTO Insider"
        static let apiVersion = "54.0"
        static let authPath = "/services/oauth2/authorize"
        static let tokenPath = "/services/oauth2/token"
        static let revokePath = "/services/oauth2/revoke"
        static let keychainAuthServiceId = "LoyaltyMobileSDK.Auth"
        static let keychainConnectedAppServiceId = "LoyaltyMobileSDK.ConnectedApp"
        static let deeplinkScheme = "loyaltyapp" // Should match URL Scheme from Info.plist
        // Orginal is "https://loyalty-management-sandbox.firebaseapp.com/__/auth/action"
        static let customActionUrlForPasswordResetEmail = "loyaltyapp://resetpassword"
        static let rewardCurrencyName = "Reward Points"
        static let rewardCurrencyNameShort = "Points"
        static let tierCurrencyName = "Tier Points"
        static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        static let connectedAppUserDefaultsKey = "LoyaltyMobileSDK.savedConnectedApp"
        static let storedInstanceURLKey = "LoyaltyMobileSDK.instanceURL"
        static let storedBaseURLKey = "LoyaltyMobileSDK.baseURL"
        static let adminMenuTapCountRequired = 6
    }
    
    struct Vouchers {
        static let codeSuccessfullyCopied = "Code successfully copied!"
    }
    
    static func config() throws -> ForceConnectedApp {
        
        guard let url = Bundle.main.url(forResource: "ConnectedApp", withExtension: "json")
                ?? Bundle.main.url(forResource: "connectedApp", withExtension: "json") else {
                throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "ConnectedApp.json"])
        }
        return try JSONDecoder().decode(ForceConnectedApp.self, from: try Data(contentsOf: url))
    }
    
    static func getInstanceURL() -> String {
        
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedInstanceURLKey) {
            return storedValue
        } else {
            return AppSettings.connectedApp.instanceURL
        }
    }
    
    static func getConnectedApp() -> ForceConnectedApp {
        
        let instance = getInstanceURL()
        
        do {
            if let app = try ForceConnectedAppKeychainManager.retrieve(for: instance) {
                return app
            }
        } catch {
            Logger.error("Failed to retrieve info for \(instance) from Keychain - \(error.localizedDescription)")
        }
        
        return connectedApp
    }
    
    static func getBaseURL() -> String {
        
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedBaseURLKey) {
            return storedValue
        } else {
            return AppSettings.connectedApp.baseURL
        }
    }

}
