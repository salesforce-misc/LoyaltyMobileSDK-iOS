//
//  VoucherViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation
import LoyaltyMobileSDK

struct VoucherTitle: Hashable, Identifiable {
	let id: String
	var title: String
}

@MainActor
class VoucherViewModel: ObservableObject, Reloadable {

    @Published var vouchers: [VoucherModel] = []
    @Published var availableVochers: [VoucherModel] = []
    @Published var redeemedVochers: [VoucherModel] = []
    @Published var expiredVochers: [VoucherModel] = []
	@Published var availableVouchersTitles: [VoucherTitle] = []
    
    enum StatusFilter: String {
        case Issued
        case Expired
        case Redeemed
        case Cancelled
        case None
    }
    
    private let vouchersFolderName = AppSettings.cacheFolders.vouchers
	private let authManager: ForceAuthenticator
	private let localFileManager: FileManagerProtocol
	private var loyaltyAPIManager: LoyaltyAPIManager
	private let expiredVouchersFilterPeriod = 30
	private let redeemedVouchersFilterPeriod = 90
	
	init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
		self.authManager = authManager
		self.localFileManager = localFileManager
		loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
											  loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
											  instanceURL: AppSettings.shared.getInstanceURL(),
											  forceClient: ForceClient(auth: authManager))
	}
	
	func loadVouchers(membershipNumber: String, devMode: Bool = false, reload: Bool = false) async throws {
		if vouchers.isEmpty || reload {
			let expiringVouchers = try await getExpiringVouchers(membershipNumber: membershipNumber, devMode: devMode, reload: reload)
			vouchers = Array(expiringVouchers.prefix(2))
		}
	}
	
	func fetchVouchers(
        membershipNumber: String,
        voucherStatus: [LoyaltyAPIManager.VoucherStatus]? = nil,
        pageNumber: Int? = nil,
        productId: [String]? = nil,
        productCategoryId: [String]? = nil,
        productName: [String]? = nil,
        productCategoryName: [String]? = nil,
        sortBy: LoyaltyAPIManager.SortBy? = nil,
        sortOrder: LoyaltyAPIManager.SortOrder? = nil,
        devMode: Bool = false) async throws -> [VoucherModel] {
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
	
	/// Returns active vouchers sorted by expiring date (Soon to be expired first)
	func getExpiringVouchers(
		membershipNumber: String,
		devMode: Bool = false,
		reload: Bool = false)
	async throws -> [VoucherModel] {
		do {
			try await loadAvailableVouchers(membershipNumber: membershipNumber, reload: reload, devMode: devMode)
			return availableVochers.sorted { firstVoucher, nextVoucher in
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				guard let firstVoucherDate = dateFormatter.date(from: firstVoucher.expirationDate),
					  let nextVoucherDate = dateFormatter.date(from: nextVoucher.expirationDate)
				else {
					return true
				}
				return firstVoucherDate < nextVoucherDate
			}
		} catch {
			throw error
		}
	}
    
    func loadFilteredVouchers(membershipNumber: String, filter: StatusFilter, devMode: Bool = false) async throws -> [VoucherModel] {
            
        // load from local cache
        if let cached = localFileManager.getData(type: [VoucherModel].self, id: membershipNumber, folderName: vouchersFolderName) {
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
                localFileManager.saveData(item: result, id: membershipNumber, folderName: vouchersFolderName, expiry: .never)
                return filtered
            } catch {
                throw error
            }
            
        }
        
    }
	
	func getTitlesOfAvailableVouchers(membershipNumber: String) async throws {
		availableVouchersTitles = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Issued).map {
			VoucherTitle(id: $0.id, title: $0.voucherDefinition)
		}
	}
    
    func reloadFilteredVouchers(membershipNumber: String, filter: StatusFilter, devMode: Bool = false) async throws -> [VoucherModel] {
        do {
            let result = try await fetchVouchers(membershipNumber: membershipNumber, devMode: devMode)
            let filtered = result.filter { voucher in
                voucher.status == filter.rawValue
            }
            
            // save to local
            localFileManager.saveData(item: result, id: membershipNumber, folderName: vouchersFolderName, expiry: .never)
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
				let allRedeemedVouchers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed, devMode: devMode)
				redeemedVochers = getRecentlyRedeemedVouchers(from: allRedeemedVouchers, withinDays: redeemedVouchersFilterPeriod)
			} catch {
				throw error
			}
		} else {
			if redeemedVochers.isEmpty {
				let allRedeemedVouchers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Redeemed, devMode: devMode)
				redeemedVochers = getRecentlyRedeemedVouchers(from: allRedeemedVouchers, withinDays: redeemedVouchersFilterPeriod)
			}
		}
	}
	
	func loadExpiredVouchers(membershipNumber: String, reload: Bool = false, devMode: Bool = false) async throws {
		if reload {
			do {
				let allExpiredVouchers = try await reloadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired, devMode: devMode)
				expiredVochers = getRecentlyExpiredVouchers(from: allExpiredVouchers, withinDays: expiredVouchersFilterPeriod)
			} catch {
				throw error
			}
		} else {
			if expiredVochers.isEmpty {
				let allExpiredVouchers = try await loadFilteredVouchers(membershipNumber: membershipNumber, filter: .Expired, devMode: devMode)
				expiredVochers = getRecentlyExpiredVouchers(from: allExpiredVouchers, withinDays: expiredVouchersFilterPeriod)
			}
		}
	}
	
	final func getRecentlyExpiredVouchers(
		from vouchers: [VoucherModel],
		withinDays days: Int,
		currentDate: Date? = Date()
	) -> [VoucherModel] {
		let recentVouchers = vouchers.filter { voucher in
			guard let expirationDate = voucher.expirationDate.toDate(),
				  let thresholdDate = currentDate?.getDate(beforeDays: days)
			else { return false }
			return expirationDate > thresholdDate
		}
		return recentVouchers
	}
	
	final func getRecentlyRedeemedVouchers(
		from vouchers: [VoucherModel],
		withinDays days: Int,
		currentDate: Date? = Date()
	) -> [VoucherModel] {
		let recentVouchers = vouchers.filter { voucher in
			guard let redeemedDate = voucher.useDate?.toDate(),
				  let thresholdDate = currentDate?.getDate(beforeDays: days)
			else { return false }
			return redeemedDate > thresholdDate
		}
		return recentVouchers
	}
    
    @MainActor
    func clear() {
        vouchers = []
        availableVochers = []
        redeemedVochers = []
        expiredVochers = []
    }
	
	@MainActor
	func reload(id: String, number: String) async throws {
		try await self.loadVouchers(membershipNumber: number, reload: true)
	}
	
}
