//
//  TransactionModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/20/22.
//

import Foundation

// MARK: - TransactionModel
struct TransactionModel: Codable {
    let status, programName, membershipNumber: String
    let recordCount: Int
    let transactionHistory: [TransactionHistory]
}

// MARK: - TransactionHistory
struct TransactionHistory: Codable, Identifiable {
    var id: String = UUID().uuidString
    let transactionAmount: Int?
    let productDetails: ProductDetails?
    let memberCurrency: [TransactionCurrency]
    let activityDate, activity: String
    
    func getCurrencyPoints(currencyName: String) -> Int {
        for currency in memberCurrency {
            if currency.name.capitalized == currencyName.capitalized {
                return Int(currency.value)
            }
        }
        return 0
    }
}

// MARK: - MemberCurrency
struct TransactionCurrency: Codable {
    let value: Double
    let name: String
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let productCategory, product: String?
    let partner: String?
}
