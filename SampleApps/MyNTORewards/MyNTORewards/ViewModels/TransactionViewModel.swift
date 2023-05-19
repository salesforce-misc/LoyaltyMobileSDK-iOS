//
//  TransactionViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/31/22.
//
import Foundation
import LoyaltyMobileSDK

class TransactionViewModel: ObservableObject, Reloadable {
 
    @Published var transactions: [TransactionJournal] = []
    @Published var recentTransactions: [TransactionJournal] = []
    @Published var olderTransactions: [TransactionJournal] = []
    
    private let transactionFolderName = "TransactionJournal"
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL(), forceClient: ForceClient(auth: authManager))
    }
    
    @MainActor
    func loadTransactions(membershipNumber: String, devMode: Bool = false) async throws {
        if transactions.isEmpty {
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [TransactionJournal].self, id: membershipNumber, folderName: transactionFolderName) {
                transactions = Array(cached.prefix(3))
            } else {
                do {
                    do {
                        let result = try await fetchTransactions(membershipNumber: membershipNumber, devMode: devMode)
                        transactions = Array(result.prefix(3))
                        
                        // save to local
                        localFileManager.saveData(item: result, id: membershipNumber, folderName: transactionFolderName, expiry: .never)
                    } catch {
                        throw error
                    }
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func fetchTransactions(membershipNumber: String, devMode: Bool = false) async throws -> [TransactionJournal] {
        do {
            let result = try await loyaltyAPIManager.getTransactions(for: membershipNumber, devMode: devMode)
            let filtered = result.filter { transaction in
                transaction.pointsChange.contains { currency in
                    currency.loyaltyMemberCurrency == AppSettings.Defaults.rewardCurrencyName
                }
            }
            return filtered
        } catch {
            throw error
        }
    }
    
    func reloadTransactions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let result = try await fetchTransactions(membershipNumber: membershipNumber, devMode: devMode)
            
            await MainActor.run {
                transactions = Array(result.prefix(3))
            }
            
            // save to local
            localFileManager.saveData(item: result, id: membershipNumber, folderName: transactionFolderName, expiry: .never)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func loadAllTransactions(membershipNumber: String, devMode: Bool = false) async throws {
        if recentTransactions.isEmpty || olderTransactions.isEmpty {
            // load from local cache
            if let cached = localFileManager.getData(type: [TransactionJournal].self, id: membershipNumber, folderName: transactionFolderName) {
                // filter recent transactions - within a month
                let recent = cached.filter { transaction in
                    guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                        return false
                    }
                    return date >= Date().monthBefore
                }
                // filter older transactions - a month ago
                let older = cached.filter { transaction in
                    guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                        return false
                    }
                    return date < Date().monthBefore
                }
                recentTransactions = recent
                olderTransactions = older
                
            } else {
                do {
                    let result = try await fetchTransactions(membershipNumber: membershipNumber, devMode: devMode)
                    let recent = result.filter { transaction in
                        guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                            return false
                        }
                        return date >= Date().monthBefore
                    }
                    let older = result.filter { transaction in
                        guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                            return false
                        }
                        return date < Date().monthBefore
                    }
                    recentTransactions = recent
                    olderTransactions = older
                    
                    // save to local
                    localFileManager.saveData(item: result, id: membershipNumber, folderName: transactionFolderName, expiry: .never)
                } catch {
                    throw error
                }
                
            }
        }
    }
    
    func reloadAllTransactions(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let result = try await fetchTransactions(membershipNumber: membershipNumber, devMode: devMode)
            let recent = result.filter { transaction in
                guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                    return false
                }
                return date >= Date().monthBefore
            }
            let older = result.filter { transaction in
                guard let date = transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat) else {
                    return false
                }
                return date < Date().monthBefore
            }
            
            await MainActor.run {
				transactions = Array(result.prefix(3))
                recentTransactions = recent
                olderTransactions = older
            }
            
            // save to local
            localFileManager.saveData(item: result, id: membershipNumber, folderName: transactionFolderName, expiry: .never)
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

	@MainActor
	func reload(id: String, number: String) async throws {
		try await reloadAllTransactions(membershipNumber: number)
	}
}
