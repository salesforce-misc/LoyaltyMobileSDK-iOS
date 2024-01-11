//
//  UnifiedAuthenticator.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/9/24.
//

import Foundation
import LoyaltyMobileSDK
import ReferralMobileSDK

typealias Authenticator = LoyaltyMobileSDK.ForceAuthenticator & ReferralMobileSDK.ForceAuthenticator
