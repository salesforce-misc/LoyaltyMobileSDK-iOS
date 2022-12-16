//
//  TransactionModel+CurrencyPoints.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 12/15/22.
//

import Foundation
import LoyaltyMobileSDK

extension TransactionHistory {
    
    func getCurrencyPoints(currencyName: String) -> Int {
        for currency in memberCurrency {
            if currency.name.capitalized == currencyName.capitalized {
                return Int(currency.value)
            }
        }
        return 0
    }
}
