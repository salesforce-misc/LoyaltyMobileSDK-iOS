//
//  AppConstants.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation

struct AppConstants {
   
    struct Config {
        static let apiVersion = "54.0"
        static let deeplinkScheme = "loyaltyapp" // Should match URL Scheme from Info.plist
        static let customActionUrlForPasswordResetEmail = "loyaltyapp://resetpassword" // orginal is "https://loyalty-management-sandbox.firebaseapp.com/__/auth/action"
        static let rewardCurrencyName = "Reward Points"
        static let rewardCurrencyNameShort = "Points"
        static let tierCurrencyName = "Tier Points"
        static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    struct Vouchers {
        static let codeSuccessfullyCopied = "Code Successfully Copied!!!"
    }
}


