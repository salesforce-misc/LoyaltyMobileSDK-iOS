//
//  VoucherViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class VoucherViewModel: ObservableObject {

    @Published var vouchers: [VoucherModel] = []
    @Published var availableVochers: [VoucherModel] = []
    @Published var redeemedVochers: [VoucherModel] = []
    @Published var expiredVochers: [VoucherModel] = []
    
    enum statusFilter: String {
        case Issued
        case Expired
        case Redeemed
        case Cancelled
        case None
    }
    
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL())
    }
    
    func loadVouchers(membershipNumber: String, devMode: Bool = false) async throws {
        
        if vouchers.isEmpty {
            
            // load from local cache
            if let cached = localFileManager.getData(type: [VoucherModel].self, id: membershipNumber, folderName: "Vouchers") {
                vouchers = Array(cached.prefix(2))
            } else {
                do {
                    let result = try await fetchVouchers(membershipNumber: membershipNumber, devMode: devMode)
                    vouchers = Array(result.prefix(2))
                    
                    // save to local
                    localFileManager.saveData(item: result, id: membershipNumber, folderName: "Vouchers", expiry: .never)
                } catch {
                    throw error
                }
                
            }
            
        }
        
    }
    
    func reloadVouchers(membershipNumber: String, devMode: Bool = false) async throws {
        do {
            let result = try await fetchVouchers(membershipNumber: membershipNumber, devMode: devMode)
            vouchers = Array(result.prefix(2))
            
            // save to local
            localFileManager.saveData(item: result, id: membershipNumber, folderName: "Vouchers", expiry: .never)
        } catch {
            throw error
        }
    }
    
    func fetchVouchers(membershipNumber: String,
                       voucherStatus: [LoyaltyAPIManager.VoucherStatus]? = nil,
                       pageNumber: Int? = nil,
                       productId: [String]? = nil,
                       productCategoryId: [String]? = nil,
                       productName: [String]? = nil,
                       productCategoryName: [String]? = nil,
                       sortBy: LoyaltyAPIManager.SortBy? = nil,
                       sortOrder: LoyaltyAPIManager.SortOrder? = nil,
                       devMode: Bool = false
    ) async throws -> [VoucherModel] {
        do {
            return try await loyaltyAPIManager.getVouchers(membershipNumber: membershipNumber,
                                                           voucherStatus: voucherStatus,
                                                           pageNumber: pageNumber,
                                                           productId: productId,
                                                           productCategoryId: productCategoryId,
                                                           productName: productName,
                                                           productCategoryName: productCategoryName,
                                                           sortBy: sortBy,
                                                           sortOrder: sortOrder,
                                                           devMode: devMode)
        } catch {
            throw error
        }
    }
    
    func loadFilteredVouchers(membershipNumber: String, filter: statusFilter, devMode: Bool = false) async throws -> [VoucherModel] {
            
        // load from local cache
        if let cached = localFileManager.getData(type: [VoucherModel].self, id: membershipNumber, folderName: "Vouchers") {
            let filtered = cached.filter { voucher in
                voucher.status == filter.rawValue
            }
            
            return filtered
            
        } else {
            do {
                let result = try await fetchVouchers(membershipNumber: membershipNumber, devMode: devMode)
                let filtered = result.filter { voucher in
                    voucher.status == filter.rawValue
                }
                
                // save to local
                localFileManager.saveData(item: result, id: membershipNumber, folderName: "Vouchers", expiry: .never)
                return filtered
            } catch {
                throw error
            }
            
        }
        
    }
    
    func reloadFilteredVouchers(membershipNumber: String, filter: statusFilter,  devMode: Bool = false) async throws -> [VoucherModel] {
        do {
            let result = try await fetchVouchers(membershipNumber: membershipNumber, devMode: devMode)
            let filtered = result.filter { voucher in
                voucher.status == filter.rawValue
            }
            
            // save to local
            localFileManager.saveData(item: result, id: membershipNumber, folderName: "Vouchers", expiry: .never)
            return filtered
        } catch {
            throw error
        }
        
    }
    
    func loadAvailableVouchers(membershipNumber: String, reload: Bool = false, devMode: Bool = false) async throws {
        if reload {
            do {
                availableVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Issued, devMode: devMode)
            } catch {
                throw error
            }
        } else {
            if availableVochers.isEmpty {
                availableVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Issued, devMode: devMode)
            }
        }
    }
    
    func loadRedeemedVouchers(membershipNumber: String, reload: Bool = false, devMode: Bool = false) async throws {
        if reload {
            do {
                redeemedVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed, devMode: devMode)
            } catch {
                throw error
            }
        } else {
            if redeemedVochers.isEmpty {
                redeemedVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed, devMode: devMode)
            }
        }
    }
    
    func loadExpiredVouchers(membershipNumber: String, reload: Bool = false, devMode: Bool = false) async throws {
        if reload {
            do {
                expiredVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired, devMode: devMode)
            } catch {
                throw error
            }
        } else {
            if expiredVochers.isEmpty {
                expiredVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired, devMode: devMode)
            }
        }
    }
    
    @MainActor
    func clear() {
        vouchers = []
        availableVochers = []
        redeemedVochers = []
        expiredVochers = []
    }
}
