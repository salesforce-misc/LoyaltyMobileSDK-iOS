//
//  ReferralViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/20/23.
//

import Foundation
import SwiftUI
import ReferralMobileSDK

@MainActor
class ReferralViewModel: ObservableObject {
    
    @Published var promotionStageCounts: [PromotionStageType: Int] = [:]
    @Published var recentReferralsSuccess: [Referral] = []
    @Published var oneMonthAgoReferralsSuccess: [Referral] = []
    @Published var threeMonthsAgoReferralsSuccess: [Referral] = []
    @Published var recentReferralsInProgress: [Referral] = []
    @Published var oneMonthAgoReferralsInProgress: [Referral] = []
    @Published var threeMonthsAgoReferralsInProgress: [Referral] = []
    @Published var referralCode: String {
        didSet {
            UserDefaults.standard.setValue(referralCode, forKey: "referralCode")
        }
    }
    @Published var displayMessage: String = ""
    
    private let authManager: ForceAuthenticator
    private let forceClient: ForceClient
    private let referralAPIManager: ReferralAPIManager
    private let localFileManager: FileManagerProtocol
    private let referralsFolderName = AppSettings.cacheFolders.referrals
    private let promotionCode = AppSettings.Defaults.promotionCode
    
    init(
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil,
        localFileManager: FileManagerProtocol = LocalFileManager.instance
    ) {
        self.authManager = authManager
        self.forceClient = forceClient ?? ForceClient(auth: authManager)
        self.referralAPIManager = ReferralAPIManager(auth: self.authManager,
                                                     referralProgramName: AppSettings.Defaults.referralProgramName,
                                                     instanceURL: AppSettings.shared.getInstanceURL(),
                                                     forceClient: self.forceClient)
        self.localFileManager = localFileManager
        self.referralCode = UserDefaults.standard.string(forKey: "referralCode") ?? ""
    }
    
    func loadAllReferrals(reload: Bool = false, devMode: Bool = false) async throws {
        if !reload {
            if let cached = localFileManager.getData(type: [Referral].self, id: promotionCode, folderName: referralsFolderName) {
                promotionStageCounts = calculatePromotionStageCounts(in: cached)
                filterReferrals(referrals: cached)
                return
            } else {
                do {
                    let result = try await fetchAllReferrals(devMode: devMode)
                    promotionStageCounts = calculatePromotionStageCounts(in: result)
                    filterReferrals(referrals: result)
                    
                    // save to local
                    localFileManager.saveData(item: result, id: promotionCode, folderName: referralsFolderName, expiry: .never)
                } catch {
                    Logger.error(error.localizedDescription)
                    throw error
                }
            }
            
        } else {
            do {
                let result = try await fetchAllReferrals(devMode: devMode)
                promotionStageCounts = calculatePromotionStageCounts(in: result)
                filterReferrals(referrals: result)
                
                // save to local
                localFileManager.saveData(item: result, id: promotionCode, folderName: referralsFolderName, expiry: .never)
            } catch {
                Logger.error(error.localizedDescription)
                throw error
            }
        }
    }
    
    func fetchAllReferrals(devMode: Bool = false) async throws -> [Referral] {
        // swiftlint:disable:next line_length
        let query = "SELECT ReferrerId, Id, ClientEmail, ReferrerEmail, ReferralDate, CurrentPromotionStage.Type FROM Referral WHERE ReferralDate = LAST_90_DAYS ORDER BY ReferralDate DESC"
        
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: [Referral].self, file: "Referrals")
                return result
            }
            let queryResult = try await forceClient.SOQL(type: Referral.self, for: query)
            return queryResult.records
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
    
    func loadReferralCode(membershipNumber: String) async {
        let notFound = "NOTFOUND"
        do {
            if let code = try await getReferralCode(for: membershipNumber) {
                referralCode = "\(promotionCode)-\(code)"
            } else {
                referralCode = "\(promotionCode)-\(notFound)"
            }
        } catch {
            referralCode = "\(promotionCode)-\(notFound)"
        }
    }
    
    func sendReferral(email: String) async {
        let emailArray = emailStringToArray(emailString: email)
        do {
            _ = try await referralAPIManager.referralEvent(emails: emailArray, referralCode: referralCode)
        } catch CommonError.responseUnsuccessful(_, let errorMessage), CommonError.unknownException(let errorMessage) {
            displayMessage = errorMessage
        } catch {
            displayMessage = error.localizedDescription
        }
    }
    
    func isMemberEnrolled(membershipNumber: String) async -> Bool {
        
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id FROM LoyaltyProgramMbrPromotion WHERE LoyaltyProgramMember.MembershipNumber = '\(membershipNumber)' AND Promotion.PromotionCode = '\(promotionCode)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            return queryResult.records.isEmpty == false
        } catch {
            Logger.error(error.localizedDescription)
            return false
        }
    }
    
    func enroll(membershipNumber: String) async {
        do {
            let success = try await referralAPIManager.referralEnrollment(membershipNumber: membershipNumber, promotionCode: promotionCode)
            if success {
                displayMessage = "You are successfully joined."
            } else {
                displayMessage = "Failed to join, please try again later."
            }
        } catch CommonError.responseUnsuccessful(_, let errorMessage), CommonError.unknownException(let errorMessage) {
            displayMessage = errorMessage
        } catch {
            displayMessage = error.localizedDescription
        }
    }
    
    private func emailStringToArray(emailString: String) -> [String] {
        return emailString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    private func getReferralCode(for membershipNumber: String) async throws -> String? {
        let query = "SELECT Id, ReferralCode FROM LoyaltyProgramMember WHERE MembershipNumber = '\(membershipNumber)'"
        
        do {
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            let referral = queryResult.records.first
            return referral?.string(forField: "ReferralCode")
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }

    private func calculatePromotionStageCounts(in referrals: [Referral]) -> [PromotionStageType: Int] {
        var counts = [PromotionStageType: Int]()

        for referral in referrals {
            if let stageType = PromotionStageType(rawValue: referral.currentPromotionStage.type) {
                counts[stageType, default: 0] += 1
            }
        }
        return counts
    }
    
    private func filterReferrals(referrals: [Referral]) {
        recentReferralsSuccess = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date >= Date().monthBefore && referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        recentReferralsSuccess = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date >= Date().monthBefore && referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
        
        oneMonthAgoReferralsSuccess = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date < Date().monthBefore && 
                date >= Date().threeMonthsBefore &&
                referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        oneMonthAgoReferralsInProgress = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date < Date().monthBefore && 
                date >= Date().threeMonthsBefore &&
                referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
        
        threeMonthsAgoReferralsSuccess = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date < Date().threeMonthsBefore && referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        threeMonthsAgoReferralsInProgress = referrals.filter { referral in
            guard let date = referral.referralDate.toDate(withFormat: AppSettings.Defaults.referralDateFormatWithoutTime) else {
                return false
            }
            
            return date < Date().threeMonthsBefore && referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
            
    }

}
