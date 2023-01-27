//
//  TransactionModel+CurrencyPoints.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/15/22.
//

import Foundation
import LoyaltyMobileSDK

extension TransactionHistory {
    
    func getCurrencyPoints(currencyName: String) -> Double {
        for currency in memberCurrency {
            if currency.name.capitalized == currencyName.capitalized {
                return currency.value
            }
        }
        return 0
    }
}
