//
//  AppConstants.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation
import LoyaltyMobileSDK

struct AppSettings {
    
    static var shared = AppSettings()
        
    private let connectedApp: ForceConnectedApp
    
    private init() {
        guard let connectedAppSettings = Bundle.main.infoDictionary?["ConnectedApp"] as? [String: Any] else {
            fatalError("Failed to load ConnectedApp settings from Info.plist.")
        }
        self.connectedApp = ForceConnectedApp(
            connectedAppName: connectedAppSettings["CONNECTED_APP_NAME"] as? String ?? "Default",
            consumerKey: connectedAppSettings["CONSUMER_KEY"] as? String ?? "",
            consumerSecret: connectedAppSettings["CONSUMER_SECRET"] as? String ?? "",
            callbackURL: connectedAppSettings["CALLBACK_URL"] as? String ?? "",
            baseURL: connectedAppSettings["BASE_URL"] as? String ?? "",
            instanceURL: connectedAppSettings["INSTANCE_URL"] as? String ?? "",
            communityURL: connectedAppSettings["COMMUNITY_URL"] as? String ?? "",
            selfRegisterURL: connectedAppSettings["SELF_REGISTER_URL"] as? String ?? ""
        )
    }

    struct Defaults {
        static let loyaltyProgramName = "NTO Insider"
        static let apiVersion = "54.0"
        static let authPath = "/services/oauth2/authorize"
        static let tokenPath = "/services/oauth2/token"
        static let revokePath = "/services/oauth2/revoke"
        static let keychainAuthServiceId = "LoyaltyMobileSDK.Auth"
        static let keychainConnectedAppServiceId = "LoyaltyMobileSDK.ConnectedApp"
        static let deeplinkScheme = "loyaltyapp" // Should match URL Scheme from Info.plist
        static let customActionUrlForPasswordResetEmail = "loyaltyapp://resetpassword"
        static let rewardCurrencyName = "Reward Points"
        static let rewardCurrencyNameShort = "Points"
        static let tierCurrencyName = "Tier Points"
        static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        static let adminMenuTapCountRequired = 6
        static let displayDateFormat = "yyyy-MM-dd"
        
        // Keys used by UserDefaults
        static let connectedAppUserDefaultsKey = "LoyaltyMobileSDK.savedConnectedApp"
        static let storedInstanceURLKey = "LoyaltyMobileSDK.instanceURL"
        static let storedBaseURLKey = "LoyaltyMobileSDK.baseURL"
        static let storedLoyaltyProgramNameKey = "LoyaltyMobileSDK.loyaltyProgramName"
        static let storedRewardCurrencyNameKey = "LoyaltyMobileSDK.rewardCurrencyName"
        static let storedRewardCurrencyNameShortKey = "LoyaltyMobileSDK.rewardCurrencyNameShort"
        
        // Referral settings
        static let referralProgramName = loyaltyProgramName
        // Configure Referral Promotion Details below, where user can also able to enroll and refer from My Referrals screen
        static let promotionCode = "TEMPRP7"
        static let referralDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        static let referralDateFormatWithoutTime = "yyyy-MM-dd"
        /* Provided random link here instead of actual Terms and Conditions link.
        Replace with valid terms and conditions link while using the feature */
        static let referralTermsLink = "https://www.google.com"
    }
    
    struct cacheFolders {
        static let vouchers = "Vouchers"
        static let promotions = "Promotions"
        static let benefits = "Benefits"
        static let transactions = "Transactions"
        static let images = "Images"
        static let referrals = "Referrals"
    }
    
    struct Vouchers {
        static let codeSuccessfullyCopied = "Code was copied!"
    }
    
    func getInstanceURL() -> String {
        
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedInstanceURLKey) {
            return storedValue
        } else {
            return self.connectedApp.instanceURL
        }
    }
    
    func getConnectedApp() -> ForceConnectedApp {
        
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
    
    func getBaseURL() -> String {
        
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedBaseURLKey) {
            return storedValue
        } else {
            return self.connectedApp.baseURL
        }
    }
    
    func getLoyaltyProgramName() -> String {
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedLoyaltyProgramNameKey) {
            return storedValue
        } else {
            return Defaults.loyaltyProgramName
        }
    }
    
    func getRewardCurrencyName() -> String {
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedRewardCurrencyNameKey) {
            return storedValue
        } else {
            return Defaults.rewardCurrencyName
        }
    }
    
    func getRewardCurrencyNameShort() -> String {
        if let storedValue = UserDefaults.standard.string(forKey: Defaults.storedRewardCurrencyNameShortKey) {
            return storedValue
        } else {
            return Defaults.rewardCurrencyNameShort
        }
    }

}
