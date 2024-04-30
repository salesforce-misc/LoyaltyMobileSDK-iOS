//
//  BadgesViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 12/03/24.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
final class BadgesViewModel: ObservableObject {
	@Published var loyaltyProgramMemberBadges: [LoyaltyProgramMemberBadge] = []
	@Published var loyaltyProgramBadges: [LoyaltyProgramBadge] = []
	@Published var availableBadges: [Badge] = []
	@Published var achievedBadges: [Badge] = []
	@Published var previewBadges: [Badge] = []
	@Published var expiredBadges: [Badge] = []
	@Published var error: String?
	
	private let programBadgesFolderName = BadgeSettings.CacheFolders.programBadges
	private let memberBadgesFolderName = BadgeSettings.CacheFolders.memberBadges
	private let localFileManager: FileManagerProtocol
	private let loyaltyAPIManager: LoyaltyAPIManager
	private let authManager: ForceAuthenticator
	private let soqlManager: SOQLManager
	private let currentDate: Date
	
	init(
		authManager: ForceAuthenticator = ForceAuthManager.shared,
		localFileManager: FileManagerProtocol = LocalFileManager.instance,
		soqlManager: SOQLManager? = nil,
		currentDate: Date = Date()
	) {
		self.authManager = authManager
		self.localFileManager = localFileManager
		let forceClient = ForceClient(auth: authManager)
		self.loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
												   loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
												   instanceURL: AppSettings.shared.getInstanceURL(),
												   forceClient: forceClient)
		self.soqlManager = soqlManager ?? SOQLManager(forceClient: forceClient)
		self.currentDate = currentDate
	}
	
	/// - Exposed API for fetching badges:
	///	--> On first launch
	/// 	- No reload, all badges and cache are empty, so fresh API call.
	/// --> On Subsequent calls if,
	/// 	- No reload, program and member badges array are not empty, so just exits the method.
	/// 	- Reload, makes fresh API call.
	/// 	- Error, clears badges and cache. So subsequent calls make fresh API call.
	///
	/// - Parameters:
	///   - membershipNumber: used for caching
	///   - reload: indicates if the call is for reloading
	func fetchAllBadges(
		membershipNumber: String,
		memberId: String,
		reload: Bool = false,
		devMode: Bool = false,
		mockProgramBadgeFileName: String = "LoyaltyProgramBadges",
		mockMemberBadgeFileName: String = "LoyaltyProgramMemberBadges"
	) async throws {
		if reload || loyaltyProgramBadges.isEmpty || loyaltyProgramMemberBadges.isEmpty {
			if !reload,
			   let cachedProgramBadges = localFileManager.getData(type: [LoyaltyProgramBadge].self,
																  id: membershipNumber,
																  folderName: programBadgesFolderName),
			   let cachedMemberBadges = localFileManager.getData(type: [LoyaltyProgramMemberBadge].self,
																 id: membershipNumber,
																 folderName: memberBadgesFolderName) {
				self.loyaltyProgramBadges = cachedProgramBadges
				self.loyaltyProgramMemberBadges = cachedMemberBadges
				Logger.debug("\n\nLoaded loyaltyProgramBadges(\(loyaltyProgramBadges.count)) from Cache\n\n\(loyaltyProgramBadges)")
				Logger.debug("\n\nLoaded loyaltyProgramMemberBadges(\(loyaltyProgramMemberBadges.count)) from Cache\n\n\(loyaltyProgramMemberBadges)")
				loadBadges()
			} else {
				do {
					Logger.debug("\n\nFetching Badges from API... dev mode: \(devMode)")
					try await fetchProgramBadges(membershipNumber: membershipNumber,
												 devMode: devMode,
												 mockFileName: mockProgramBadgeFileName)
					try await fetchProgramMemberBadges(membershipNumber: membershipNumber,
													   devMode: devMode,
													   mockFileName: mockMemberBadgeFileName,
													   memberId: memberId)
					self.error = nil
					loadBadges()
				} catch {
					clearBadges()
					clearCache(membershipNumber: membershipNumber)
					self.error = error.localizedDescription
					Logger.error("\n\nFailed Loading Badges From API: \(error.localizedDescription)")
					throw CommonError.requestFailed(message: error.localizedDescription)
				}
			}
		}
	}
	
	private func fetchProgramMemberBadges(
		membershipNumber: String,
		devMode: Bool,
		mockFileName: String,
		memberId: String
	) async throws {
		do {
			self.loyaltyProgramMemberBadges = try await soqlManager.getProgramMemberBadges(devMode: devMode,
																						   mockFileName: mockFileName,
																						   memberId: memberId)
			Logger.debug("\n\nFetched loyaltyProgramMemberBadges(\(loyaltyProgramMemberBadges.count)) from API\n\n\(loyaltyProgramMemberBadges)")
			self.localFileManager.saveData(item: self.loyaltyProgramMemberBadges,
										   id: membershipNumber,
										   folderName: memberBadgesFolderName,
										   expiry: .never)
		} catch {
			throw error
		}
	}
	
	private func fetchProgramBadges(
		membershipNumber: String,
		devMode: Bool,
		mockFileName: String
	) async throws {
		do {
			self.loyaltyProgramBadges = try await soqlManager.getProgramBadges(devMode: devMode, mockFileName: mockFileName)
			Logger.debug("\n\nFetched loyaltyProgramBadges(\(loyaltyProgramBadges.count)) from API\n\n\(loyaltyProgramBadges)")
			self.localFileManager.saveData(item: self.loyaltyProgramBadges,
										   id: membershipNumber,
										   folderName: programBadgesFolderName,
										   expiry: .never)
		} catch {
			throw error
		}
	}
	
	/// Loads Achieved, Available & Expired badges from LoyaltyProgramBadges & LoyaltyProgramMemberBadges.
	/// Achieved Badges = LoyaltyProgramBadge's Id matching with LoyaltyProgramMemberBadge's LoyaltyProgramBadgeId and has status as active.
	/// Expired Badges = Achieved by user but expired(Achieved badges with expiry date before today). We consider LoyaltyProgramMemberBadge for expiry using endDate property.
	/// Available Badges = LoyaltyProgramBadge's Id not matching with LoyaltyProgramMemberBadge's LoyaltyProgramBadgeId
	private func loadBadges() {
		clearBadges()
		let uniqueMemberBadges = Array(Set(self.loyaltyProgramMemberBadges))
		for programBadge in self.loyaltyProgramBadges {
			var isMemberBadgeFound: Bool = false
			for memberBadge in uniqueMemberBadges
			where memberBadge.loyaltyProgramBadgeId == programBadge.id {
				isMemberBadgeFound = true
				switch memberBadge.status {
				case .active:
					appendBadges(from: programBadge,
								 and: memberBadge,
								 type: .achieved)
				case .expired:
					appendBadges(from: programBadge,
								 and: memberBadge,
								 type: .expired)
				}
			}
			if !isMemberBadgeFound,
			   let startDate = programBadge.startDate,
			   startDate <= currentDate {
				appendBadges(from: programBadge, type: .available)
			}
		}
		self.previewBadges = Array(self.achievedBadges.prefix(3))
		sortBadges()
		Logger.debug("\n\nBadges loaded:")
		Logger.debug("Preview Badges(\(previewBadges.count)):\n\(previewBadges)")
		Logger.debug("Achieved Badges(\(achievedBadges.count)):\n\(achievedBadges)")
		Logger.debug("Available Badges(\(availableBadges.count)):\n\(availableBadges)")
		Logger.debug("Expired Badges(\(expiredBadges.count)):\n\(expiredBadges)")
	}
	
	/// Creates Badge object and puts into Achieved, Available & Expired Badges array accordingly.
	/// Badge object is created since we need data from both LoyaltyProgramBadges and LoyaltyProgramMemberBadges(endDate),
	/// and to avoid complexity of passing matched LoyaltyProgramMemberBadge and LoyaltyProgramBadge objects to view
	private func appendBadges(
		from programBadge: LoyaltyProgramBadge,
		and memberBadge: LoyaltyProgramMemberBadge? = nil,
		type: BadgeType
	) {
		let badge = Badge(id: programBadge.id,
						  name: programBadge.name,
						  description: programBadge.description,
						  type: type,
						  endDate: memberBadge?.endDate, 
						  currentDate: self.currentDate,
						  imageUrl: programBadge.imageUrl)
		switch type {
		case .achieved:
			self.achievedBadges.append(badge)
		case .available:
			self.availableBadges.append(badge)
		case .expired:
			self.expiredBadges.append(badge)
		}
	}
	
	private func sortBadges() {
		self.previewBadges.sort { $0.daysToExpire ?? 0 < $1.daysToExpire ?? 0 }
		self.achievedBadges.sort { $0.daysToExpire ?? 0 < $1.daysToExpire ?? 0 }
		self.availableBadges.sort { $0.daysToExpire ?? 0 < $1.daysToExpire ?? 0 }
		self.expiredBadges.sort { $0.daysToExpire ?? 0 > $1.daysToExpire ?? 0 }
	}
	
	private func clearBadges() {
		self.previewBadges.removeAll()
		self.achievedBadges.removeAll()
		self.availableBadges.removeAll()
		self.expiredBadges.removeAll()
	}
	
	private func clearCache(membershipNumber: String) {
		self.localFileManager.removeData(type: LoyaltyProgramBadge.self, id: membershipNumber, folderName: programBadgesFolderName)
		self.localFileManager.removeData(type: LoyaltyProgramMemberBadge.self, id: membershipNumber, folderName: memberBadgesFolderName)
	}
}
