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
    
    @Published var referralMember: ReferralMember?
    @Published var showEnrollmentView = false
    @Published var promotionStageCounts: [PromotionStageType: Int] = [:]
    @Published var recentReferralsSuccess: [Referral] = []
    @Published var oneMonthAgoReferralsSuccess: [Referral] = []
    @Published var threeMonthsAgoReferralsSuccess: [Referral] = []
    @Published var recentReferralsInProgress: [Referral] = []
    @Published var oneMonthAgoReferralsInProgress: [Referral] = []
    @Published var threeMonthsAgoReferralsInProgress: [Referral] = []
    @Published private(set) var enrollmentStatusApiState = LoadingState.idle
    @Published var referralCode: String {
        didSet {
            UserDefaults.standard.setValue(referralCode, forKey: "referralCode")
        }
    }
    @Published var referralMembershipNumber: String {
        didSet {
            UserDefaults.standard.setValue(referralMembershipNumber, forKey: "referralMembershipNumber")
        }
    }
    @Published var displayError: (Bool, String) = (false, "")
    
    private let authManager: ForceAuthenticator
    private let forceClient: ForceClient
    private let referralAPIManager: ReferralAPIManager
    private let localFileManager: FileManagerProtocol
    private let referralsFolderName = AppSettings.cacheFolders.referrals
    private let promotionCode = AppSettings.Defaults.promotionCode
    private let referralProgramName = AppSettings.Defaults.loyaltyProgramName
	var devMode: Bool = false
	var isEnrolled: Bool = false
	
    init(
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil,
        localFileManager: FileManagerProtocol = LocalFileManager.instance,
		devMode: Bool = false,
		isEnrolled: Bool = false
    ) {
        self.authManager = authManager
        self.forceClient = forceClient ?? ForceClient(auth: authManager)
        self.referralAPIManager = ReferralAPIManager(auth: self.authManager,
                                                     referralProgramName: AppSettings.Defaults.loyaltyProgramName,
                                                     instanceURL: AppSettings.shared.getInstanceURL(),
                                                     forceClient: self.forceClient)
		self.devMode = devMode
		self.isEnrolled = isEnrolled
        self.localFileManager = localFileManager
        self.referralCode = UserDefaults.standard.string(forKey: "referralCode") ?? ""
        self.referralMembershipNumber = UserDefaults.standard.string(forKey: "referralMembershipNumber") ?? ""
    }
    
    func loadAllReferrals(memberContactId: String, reload: Bool = false) async throws {
        if !reload && !devMode {
            if let cached = localFileManager.getData(type: [Referral].self, id: promotionCode, folderName: referralsFolderName) {
                promotionStageCounts = calculatePromotionStageCounts(in: cached)
                filterReferrals(referrals: cached)
                return
            } else {
                do {
                    let result = try await fetchAllReferrals(memberContactId: memberContactId)
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
                let result = try await fetchAllReferrals(memberContactId: memberContactId)
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
    
    func fetchAllReferrals(memberContactId: String) async throws -> [Referral] {
        let query = """
            SELECT ReferrerId, Id, ClientEmail, ReferrerEmail, ReferralDate, CurrentPromotionStage.Type,
                TYPEOF ReferredParty
                    WHEN Contact THEN Account.PersonEmail
                    WHEN Account THEN PersonEmail
                END
            FROM Referral WHERE ReferralDate = LAST_90_DAYS AND Promotion.PromotionCode = '\(promotionCode)' AND ReferrerId = '\(memberContactId)'
            ORDER BY ReferralDate DESC
        """
        
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
                referralCode = "\(code)-\(promotionCode)"
            } else {
                referralCode = "\(notFound)-\(promotionCode)"
            }
        } catch {
            referralCode = "\(notFound)-\(promotionCode)"
        }
    }
    
    func sendReferral(email: String) async {
        let emailArray = emailStringToArray(emailString: email)
        do {
            _ = try await referralAPIManager.referralEvent(emails: emailArray, referralCode: referralCode)
        } catch CommonError.responseUnsuccessful(_, let errorMessage), CommonError.unknownException(let errorMessage) {
            displayError = (true, errorMessage)
        } catch {
            displayError = (true, error.localizedDescription)
        }
    }
    
    // Need to use referral membershipNumber
    func checkEnrollmentStatus(membershipNumber: String) async {
        
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id FROM LoyaltyProgramMbrPromotion WHERE LoyaltyProgramMember.MembershipNumber = '\(membershipNumber)' AND Promotion.PromotionCode = '\(promotionCode)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            showEnrollmentView = queryResult.records.isEmpty == true
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
    
    func checkEnrollmentStatus(contactId: String) async {
        do {
            enrollmentStatusApiState = .loading
            // swiftlint:disable:next line_length
            let query = "SELECT Id, Name, PromotionId, LoyaltyProgramMemberId, LoyaltyProgramMember.ContactId FROM LoyaltyProgramMbrPromotion where LoyaltyProgramMember.ContactId='\(contactId)' AND Promotion.PromotionCode='\(promotionCode)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            enrollmentStatusApiState = .loaded
			if devMode {
				showEnrollmentView = !isEnrolled
			} else {
				showEnrollmentView = queryResult.records.isEmpty
			}
        } catch {
            enrollmentStatusApiState = .failed(error)
            Logger.error(error.localizedDescription)
        }
    }
    
    func getMembershipNumber(contactId: String) async {
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id, MembershipNumber FROM LoyaltyProgramMember WHERE Program.Name = '\(referralProgramName)' AND Program.Type = 'REFERRAL_PROGRAM' AND Contact.Id = '\(contactId)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            let membershipNumber = queryResult.records.first?.string(forField: "MembershipNumber")
            if membershipNumber == nil {
                showEnrollmentView = true
            }
            self.referralMembershipNumber = membershipNumber ?? ""
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
    
    func enroll(membershipNumber: String) async {
        do {
            let output = try await referralAPIManager.referralEnrollment(membershipNumber: membershipNumber, promotionCode: promotionCode)
            if output.transactionJournals.first?.status.uppercased() == "PROCESSED" {
                displayError = (false, "You are successfully joined.")
                let referralMember = ReferralMember(id: output.memberID,
                                                    contactId: output.contactID,
                                                    membershipNumber: output.membershipNumber,
                                                    programName: output.programName,
                                                    promotionReferralCode: output.promotionReferralCode,
                                                    enrollmentDate: output.transactionJournals.first?.activityDate ?? Date())
                // save to local
                localFileManager.saveData(item: referralMember, id: output.membershipNumber, folderName: referralsFolderName, expiry: .never)
                self.referralMember = referralMember
                self.referralCode = output.promotionReferralCode
                self.referralMembershipNumber = output.membershipNumber
                showEnrollmentView = false
                
            } else {
                // status is not `Processed`, if `Pending` should
                Logger.debug("The enrollment status is: \(output.transactionJournals.first?.status ?? "NOTFOUND")")
                displayError = (true, StringConstants.Referrals.enrollmentError)
            }
        } catch {
            Logger.error("Referral Enrollment Error: \(error.localizedDescription)")
            displayError = (true, StringConstants.Referrals.enrollmentError)
        }
    }
    
    func enroll(contactId: String) async {
        do {
            let output = try await referralAPIManager.referralEnrollment(contactID: contactId, promotionCode: promotionCode)
            if output.transactionJournals.first?.status.uppercased() == "PROCESSED" {
                displayError = (false, "You are successfully joined.")
                let referralMember = ReferralMember(id: output.memberID,
                                                    contactId: output.contactID,
                                                    membershipNumber: output.membershipNumber,
                                                    programName: output.programName,
                                                    promotionReferralCode: output.promotionReferralCode,
                                                    enrollmentDate: output.transactionJournals.first?.activityDate ?? Date())
                // save to local
                localFileManager.saveData(item: referralMember, id: output.membershipNumber, folderName: referralsFolderName, expiry: .never)
                self.referralMember = referralMember
                self.referralCode = output.promotionReferralCode
                self.referralMembershipNumber = output.membershipNumber
                showEnrollmentView = false
                
            } else {
                // status is not `Processed`, if `Pending` should
                Logger.debug("The enrollment status is: \(output.transactionJournals.first?.status ?? "NOTFOUND")")
                displayError = (true, StringConstants.Referrals.enrollmentError)
            }
        } catch {
            Logger.error("Referral Enrollment Error: \(error.localizedDescription)")
            displayError = (true, StringConstants.Referrals.enrollmentError)
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
            return referral.referralDate >= Date().monthBefore && 
                referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        recentReferralsInProgress = referrals.filter { referral in
            return referral.referralDate >= Date().monthBefore && 
                referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
        
        oneMonthAgoReferralsSuccess = referrals.filter { referral in
            return referral.referralDate < Date().monthBefore &&
                referral.referralDate >= Date().threeMonthsBefore &&
                referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        oneMonthAgoReferralsInProgress = referrals.filter { referral in
            return referral.referralDate < Date().monthBefore &&
                referral.referralDate >= Date().threeMonthsBefore &&
                referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
        
        threeMonthsAgoReferralsSuccess = referrals.filter { referral in
            return referral.referralDate < Date().threeMonthsBefore && 
                referral.currentPromotionStage.type == PromotionStageType.voucherEarned.rawValue
        }
        
        threeMonthsAgoReferralsInProgress = referrals.filter { referral in
            return referral.referralDate < Date().threeMonthsBefore && 
                referral.currentPromotionStage.type != PromotionStageType.voucherEarned.rawValue
        }
            
    }

}
