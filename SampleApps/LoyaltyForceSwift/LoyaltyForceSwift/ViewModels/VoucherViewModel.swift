//
//  VoucherViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation
import UIKit

@MainActor
class VoucherViewModel: ObservableObject {

    @Published var vouchers: [VoucherModel] = []
    @Published var availableVochers: [VoucherModel] = []
    @Published var redeemedVochers: [VoucherModel] = []
    @Published var expiredVochers: [VoucherModel] = []
    @Published var voucherImages: [String: UIImage?] = [:]
    
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
    
    /*
    SELECT VoucherDefinition.Name, Voucher.Image__c, VoucherDefinition.Description, VoucherDefinition.Type, VoucherDefinition.FaceValue, VoucherDefinition.DiscountPercent, VoucherCode, ExpirationDate, Id, Status
    FROM Voucher
    WHERE LoyaltyProgramMember.MembershipNumber = '\(membershipNumber)'
     */
    func fetchVouchers(membershipNumber: String) async throws -> [VoucherModel] {
        
        var fetchedVouchers: [VoucherModel] = []
        
        do {
            let results = try await LoyaltyAPIManager.shared.getVoucherRecords(membershipNumber: membershipNumber)
            for result in results {
                let imageUrl = LoyaltyUtilities.getImageUrl(image: result.image, attributesUrl: result.attributes.url, fieldName: "Image__c")
                
//                if let url = imageUrl {
//                    let voucherImage = await ForceClient.shared.fetchImage(url: url)
//                    voucherImages[result.id] = voucherImage
//                } else {
//                    voucherImages[result.id] = nil
//                }
                
                let voucher = VoucherModel(id: result.id,
                                       name: result.voucherDefinition.name,
                                       description: result.voucherDefinition.description,
                                       type: result.voucherDefinition.type,
                                       faceValue: result.voucherDefinition.faceValue,
                                       discountPercent: result.voucherDefinition.discountPercent,
                                       code: result.voucherCode,
                                       expirationDate: result.expirationDate,
                                       image: imageUrl,
                                       status: result.status)
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
}
