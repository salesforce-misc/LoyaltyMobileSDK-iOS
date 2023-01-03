//
//  TransactionViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/31/22.
//

import Foundation
import LoyaltyMobileSDK

class TransactionViewModel: ObservableObject {
 
    @Published var transactions: [TransactionHistory] = []
    @Published var recentTransactions: [TransactionHistory] = []
    @Published var olderTransactions: [TransactionHistory] = []
    
    @MainActor
    func loadTransactions(membershipNumber: String) async throws {
        if transactions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [TransactionHistory].self, id: membershipNumber, folderName: "TransactionHistory") {
                transactions = Array(cached.prefix(3))
            } else {
                do {
                    do {
                        let result = try await fetchTransactions(membershipNumber: membershipNumber)
                        transactions = Array(result.prefix(3))
                        
                        // save to local
                        LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "TransactionHistory")
                    } catch {
                        throw error
                    }
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func fetchTransactions(membershipNumber: String) async throws -> [TransactionHistory] {
        do {
            let result = try await LoyaltyAPIManager.shared.getTransactions(for: membershipNumber)
            let filtered = result.filter { transaction in
                transaction.memberCurrency.contains { currency in
                    currency.name == AppConstants.Config.rewardCurrencyName
                }
            }
            return filtered
        } catch {
            throw error
        }
    }
    
    func reloadTransactions(membershipNumber: String) async throws {
        do {
            let result = try await fetchTransactions(membershipNumber: membershipNumber)
            
            await MainActor.run {
                transactions = Array(result.prefix(3))
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "TransactionHistory")
        } catch {
            throw error
        }
    }
    
    @MainActor
    func loadAllTransactions(membershipNumber: String) async throws {
        if recentTransactions.isEmpty || olderTransactions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [TransactionHistory].self, id: membershipNumber, folderName: "TransactionHistory") {
                // filter recent transactions - within a month
                let recent = cached.filter { transaction in
                    guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                        return false
                    }
                    return date >= Date().monthBefore
                }
                // filter older transactions - a month ago
                let older = cached.filter { transaction in
                    guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                        return false
                    }
                    return date < Date().monthBefore
                }
                recentTransactions = recent
                olderTransactions = older
                
            } else {
                do {
                    let result = try await fetchTransactions(membershipNumber: membershipNumber)
                    let recent = result.filter { transaction in
                        guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                            return false
                        }
                        return date >= Date().monthBefore
                    }
                    let older = result.filter { transaction in
                        guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                            return false
                        }
                        return date < Date().monthBefore
                    }
                    recentTransactions = recent
                    olderTransactions = older
                    
                    // save to local
                    LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "TransactionHistory")
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func reloadAllTransactions(membershipNumber: String) async throws {
        do {
            let result = try await fetchTransactions(membershipNumber: membershipNumber)
            let recent = result.filter { transaction in
                guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                    return false
                }
                return date >= Date().monthBefore
            }
            let older = result.filter { transaction in
                guard let date = transaction.activityDate.toDate(withFormat: "yyyy-MM-dd") else {
                    return false
                }
                return date < Date().monthBefore
            }
            
            await MainActor.run {
                recentTransactions = recent
                olderTransactions = older
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "TransactionHistory")
        } catch {
            throw error
        }
    }
    
    @MainActor
    func clear() {
        transactions = []
        recentTransactions = []
        olderTransactions = []
    }

}
