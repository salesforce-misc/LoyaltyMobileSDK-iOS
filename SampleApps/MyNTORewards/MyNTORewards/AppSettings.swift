//
//  AppConstants.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import LoyaltyMobileSDK

struct AppSettings {
    
    // Set the mode depends on debug/release deployment
    static let demoMode = false
    
    static let connectedApp = ForceConnectedApp(
        consumerKey: "3MVG9sA57VMGPDff5IP2PZ3gePzAE087y65OQNiwULLemkJnFilih4d4Ttixw0abfb8XH__8miW3Xn9yStqlg",
        consumerSecret: "4C64F15ECE02FFF0002BA74DFDE835A94FE05C7DC1DA3096604E634701E844AA",
        callbackURL: "https://dro000000kef12ao.test1.my.pc-rnd.site.com/oauth2/callback",
        baseURL: "https://na45.test1.pc-rnd.salesforce.com",
        instanceURL: "https://dro000000kef12ao.test1.my.pc-rnd.salesforce.com",
        communityURL: "https://dro000000kef12ao.test1.my.pc-rnd.site.com",
        username: "archit.sharma@salesforce.com",
        password: "test@321"
    )

    struct Defaults {
        static let loyaltyProgramName = "NTO Insider"
        static let apiVersion = "54.0"
        static let authPath = "/services/oauth2/authorize"
        static let tokenPath = "/services/oauth2/token"
        static let revokePath = "/services/oauth2/revoke"
        static let serviceIdentifier = "com.salesforce.industries.mobile"
        static let deeplinkScheme = "loyaltyapp" // Should match URL Scheme from Info.plist
        static let customActionUrlForPasswordResetEmail = "loyaltyapp://resetpassword" // orginal is "https://loyalty-management-sandbox.firebaseapp.com/__/auth/action"
        static let rewardCurrencyName = "Reward Points"
        static let rewardCurrencyNameShort = "Points"
        static let tierCurrencyName = "Tier Points"
        static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        static let connectedAppUserDefaultsKey = "savedConnectedApp"
    }
    
    struct Vouchers {
        static let codeSuccessfullyCopied = "Code successfully copied!"
    }
    
    static func config() throws -> ForceConnectedApp {
        
        guard let url = Bundle.main.url(forResource: "ConnectedApp", withExtension: "json")
                ?? Bundle.main.url(forResource: "connectedApp", withExtension: "json") else {
                throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey : "ConnectedApp.json"])
        }
        return try JSONDecoder().decode(ForceConnectedApp.self, from: try Data(contentsOf: url))
    }
    
    // get the correct connectedApp for API
    static func getConnectedApp() -> ForceConnectedApp {
        
        // demo app used by SEs
        if demoMode {
            // retrieve from userDefaults
            let userDefaults = UserDefaults.standard
            if let savedAppData = userDefaults.object(forKey: Defaults.connectedAppUserDefaultsKey) as? Data {
                let decoder = JSONDecoder()
                if let savedConnectedApp = try? decoder.decode(ForceConnectedApp.self, from: savedAppData) {
                    return savedConnectedApp
                }
                return connectedApp
            }
            return connectedApp
        }
        return connectedApp
    }

}


