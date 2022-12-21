//
//  ProfileModel+CurrencyPoints.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/15/22.
//

import Foundation
import LoyaltyMobileSDK

extension ProfileModel {
    
    func getCurrencyPoints(currencyName: String) -> Int {
        for currency in memberCurrencies {
            if currency.loyaltyMemberCurrencyName.capitalized == currencyName.capitalized {
                return currency.pointsBalance
            }
        }
        return 0
    }
}
