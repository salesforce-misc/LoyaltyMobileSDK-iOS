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
    
    func loadVouchers(membershipNumber: String) async throws {
        
        if vouchers.isEmpty {
            
            // load from local cache
            if let cached = LocalFileManager.instance.getData(type: [VoucherModel].self, id: membershipNumber, folderName: "Vouchers") {
                vouchers = Array(cached.prefix(2))
            } else {
                do {
                    let result = try await fetchVouchers(membershipNumber: membershipNumber)
                    vouchers = Array(result.prefix(2))
                    
                    // save to local
                    LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "Vouchers")
                } catch {
                    throw error
                }
                
            }
            
        }
        
    }
    
    func reloadVouchers(membershipNumber: String) async throws {
        do {
            let result = try await fetchVouchers(membershipNumber: membershipNumber)
            vouchers = Array(result.prefix(2))
            
            // save to local
            LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "Vouchers")
        } catch {
            throw error
        }
    }
    
    func fetchVouchers(membershipNumber: String) async throws -> [VoucherModel] {
        
        var fetchedVouchers: [VoucherModel] = []
        
        do {
			let queryItems = [URLQueryItem(name: "voucherStatus", value: "xx, yy, zz")]
            let results = try await LoyaltyAPIManager.shared.getVouchers(membershipNumber: membershipNumber, devMode: true, queryItems: queryItems)
            for result in results {
				let imageUrl = LoyaltyUtilities.getImageUrl(image: result.voucherImageUrl, attributesUrl: result.attributesUrl, fieldName: "Image__c")
                
				let voucher = VoucherModel(id: result.voucherId ?? "",
										   name: result.voucherDefinition ?? "",
										   description: result.description,
										   type: result.type ?? "",
										   faceValue: "\(result.faceValue ?? 0)",
										   discountPercent: "\(result.discountPercent ?? 0)",
										   code: result.voucherCode,
										   expirationDate: result.expirationDate ?? "",
										   image: imageUrl,
										   status: result.status ?? "",
										   partnerAccount: result.partnerAccount,
										   product: result.product, productCategory: result.productCategory,
										   voucherNumber: result.voucherNumber,
										   effectiveDate: result.effectiveDate,
										   redeemedValue: result.redeemedValue,
										   remainingValue: result.remainingValue, currencyIsoCode: result.currencyIsoCode,
										   isVoucherDefinitionActive: result.isVoucherDefinitionActive ?? false,
										   isVoucherPartiallyRedeemable: result.isVoucherPartiallyRedeemable ?? false,
										   productId: result.productId, productCategoryId: result.productCategoryId,
										   useDate: result.useDate,
										   promotionName: result.promotionName,
										   promotionId: result.promotionId)
                fetchedVouchers.append(voucher)
            }
            return fetchedVouchers
            
        } catch {
            throw error
        }
    }
    
    func loadFilteredVouchers(membershipNumber: String, filter: statusFilter) async throws -> [VoucherModel] {
            
        // load from local cache
        if let cached = LocalFileManager.instance.getData(type: [VoucherModel].self, id: membershipNumber, folderName: "Vouchers") {
            let filtered = cached.filter { voucher in
                voucher.status == filter.rawValue
            }
            
            return filtered
            
        } else {
            do {
                let result = try await fetchVouchers(membershipNumber: membershipNumber)
                let filtered = result.filter { voucher in
                    voucher.status == filter.rawValue
                }
                
                // save to local
                LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "Vouchers")
                return filtered
            } catch {
                throw error
            }
            
        }
        
    }
    
    func reloadFilteredVouchers(membershipNumber: String, filter: statusFilter) async throws -> [VoucherModel] {
        do {
            let result = try await fetchVouchers(membershipNumber: membershipNumber)
            let filtered = result.filter { voucher in
                voucher.status == filter.rawValue
            }
            
            // save to local
            LocalFileManager.instance.saveData(item: result, id: membershipNumber, folderName: "Vouchers")
            return filtered
        } catch {
            throw error
        }
        
    }
    
    func loadAvailableVouchers(membershipNumber: String, reload: Bool = false) async throws {
        if reload {
            do {
                availableVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Issued)
            } catch {
                throw error
            }
        } else {
            if availableVochers.isEmpty {
                availableVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Issued)
            }
        }
    }
    
    func loadRedeemedVouchers(membershipNumber: String, reload: Bool = false) async throws {
        if reload {
            do {
                redeemedVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed)
            } catch {
                throw error
            }
        } else {
            if redeemedVochers.isEmpty {
                redeemedVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed)
            }
        }
    }
    
    func loadExpiredVouchers(membershipNumber: String, reload: Bool = false) async throws {
        if reload {
            do {
                expiredVochers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired)
            } catch {
                throw error
            }
        } else {
            if expiredVochers.isEmpty {
                expiredVochers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired)
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
