//
//  CheckoutNetworkConfig.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation

public struct CheckoutConfig {
	
	public struct Defaults {
		public static let loyaltyProgramName = "NTO Insider"
		public static let apiVersion = "54.0"
		public static let authPath = "/services/oauth2/authorize"
		public static let tokenPath = "/services/oauth2/token"
		public static let revokePath = "/services/oauth2/revoke"
		public static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		public static let connectedAppUserDefaultsKey = "LoyaltyMobileSDK.savedConnectedApp"
		public static let connectedAppName = "Default"
		public static let username = "admin_aa_22852@loyaltysampleapp.com"
		public static let password = "test@321"
		public static let orderCheckout = "services/apexrest/NTOOrderCheckOut/"
		public static let consumerKey = "3MVG9kBt168mda_.AhACC.RZAxIT77sS1y2_ltn1YMi4tG98ZA1nMiP2w6m51xen0Of_0TWZ8RTvPy05bK5p9"
		public static let consumerSecret = "F89D25E00C8295DBDD0F8AD08750E69633B6E46B6515AA8BED7D30CDEEA2BD5E"
		public static let callbackURL = "https://dro000000kef12ao.test1.my.pc-rnd.site.com/oauth2/callback"
		public static let baseURL = "https://internalmobileteam-dev-ed.develop.my.salesforce.com/"
		public static let instanceURL = "https://dro000000kef12ao.test1.my.pc-rnd.salesforce.com"
		public static let communityURL = "https://dro000000kef12ao.test1.my.pc-rnd.site.com"
	}
}
