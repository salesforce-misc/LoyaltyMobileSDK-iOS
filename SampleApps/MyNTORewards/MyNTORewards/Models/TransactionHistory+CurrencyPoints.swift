//
//  TransactionModel+CurrencyPoints.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/15/22.
//

import Foundation
import LoyaltyMobileSDK

extension TransactionJournal {
    
    func getCurrencyPoints(currencyName: String) -> Double {
        for currency in pointsChange {
            if currency.loyaltyMemberCurrency.capitalized == currencyName.capitalized {
                return currency.changeInPoints
            }
        }
        return 0
    }
}
