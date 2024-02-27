//
//  ReferralViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/20/23.
//

import Foundation
import SwiftUI
import ReferralMobileSDK

struct ReferralPromotionObject: Codable {
    let isReferralPromotion: Bool?
    let promotionCode: String?
    let id: String
    let name: String
    let description: String?
    let promotionImageUrl: String?
    let promotionPageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case isReferralPromotion = "IsReferralPromotion"
        case promotionCode = "PromotionCode"
        case id = "Id"
        case name = "Name"
        case description = "Description"
        case promotionImageUrl = "ImageUrl"
        case promotionPageUrl = "PromotionPageUrl"
    }
}

enum DefaultPromotionGateWayViewScreenState {
    case joinReferralPromotion
    case referFriend
    case promotionError
}

@MainActor
class ReferralViewModel: ObservableObject {
    
    @Published var referralMember: ReferralMember?
    @Published var defaultPromotionInfo: ReferralPromotionObject?
    @Published var promotionStageCounts: [PromotionStageType: Int] = [:]
    @Published var recentReferralsSuccess: [Referral] = []
    @Published var oneMonthAgoReferralsSuccess: [Referral] = []
    @Published var threeMonthsAgoReferralsSuccess: [Referral] = []
    @Published var recentReferralsInProgress: [Referral] = []
    @Published var oneMonthAgoReferralsInProgress: [Referral] = []
    @Published var threeMonthsAgoReferralsInProgress: [Referral] = []
    @Published private(set) var loadAllReferralsApiState = LoadingState.idle
    @Published private(set) var enrollmentStatusApiState = LoadingState.idle
    @Published private(set) var promotionScreenType: DefaultPromotionGateWayViewScreenState = .joinReferralPromotion
    @Published var referralCode: String
    
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
                                                     referralProgramName: AppSettings.Defaults.referralProgramName,
                                                     instanceURL: AppSettings.shared.getInstanceURL(),
                                                     forceClient: self.forceClient)
        self.devMode = devMode
        self.isEnrolled = isEnrolled
        self.localFileManager = localFileManager
        self.referralMembershipNumber = UserDefaults.standard.string(forKey: "referralMembershipNumber") ?? ""
        self.referralCode = ""
    }
    
    func loadAllReferrals(memberContactId: String, reload: Bool = false) async throws {
        if !reload && !devMode {
            
            if let cached = localFileManager.getData(type: [Referral].self, id: promotionCode, folderName: referralsFolderName) {
                promotionStageCounts = calculatePromotionStageCounts(in: cached)
                filterReferrals(referrals: cached)
                loadAllReferralsApiState = .loaded
                return
            } else {
                loadAllReferralsApiState = .loading
                do {
                    let result = try await fetchAllReferrals(memberContactId: memberContactId)
                    promotionStageCounts = calculatePromotionStageCounts(in: result)
                    filterReferrals(referrals: result)
                    
                    // save to local
                    loadAllReferralsApiState = .loaded
                    localFileManager.saveData(item: result, id: promotionCode, folderName: referralsFolderName, expiry: .never)
                } catch {
                    loadAllReferralsApiState = .failed(error)
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
    
    func getReferralsDataFromServer(memberContactId: String) async throws {
        do {
            loadAllReferralsApiState = .loading
            let result = try await fetchAllReferrals(memberContactId: memberContactId)
            promotionStageCounts = calculatePromotionStageCounts(in: result)
            filterReferrals(referrals: result)
            loadAllReferralsApiState = .loaded
            
            // save to local
            localFileManager.saveData(item: result, id: promotionCode, folderName: referralsFolderName, expiry: .never)
        } catch {
            Logger.error(error.localizedDescription)
            loadAllReferralsApiState = .failed(error)
            throw error
        }
    }
    
    func fetchAllReferrals(memberContactId: String) async throws -> [Referral] {
        let query = """
            SELECT ReferrerId, Id, ClientEmail, ReferrerEmail, ReferralDate, CurrentPromotionStage.Type,
                TYPEOF ReferredParty
                    WHEN Contact THEN Account.PersonEmail
                    WHEN Account THEN PersonEmail
                END
            FROM Referral WHERE ReferralDate = LAST_90_DAYS AND ReferrerId = '\(memberContactId)'
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
    
    func loadReferralCode(membershipNumber: String, promoCode: String) async {
        let notFound = "NOTFOUND"
        do {
            if let code = try await getReferralCode(for: membershipNumber) {
                referralCode = code
            } else {
                referralCode = notFound
            }
        } catch {
            referralCode = notFound
        }
    }
    
    func sendReferral(email: String, promoCode: String?) async throws {
        let emailArray = emailStringToArray(emailString: email)
        do {
            _ = try await referralAPIManager.referralEvent(emails: emailArray, referralCode: "\(referralCode)-\(promoCode ?? promotionCode)")
        } catch CommonError.responseUnsuccessful(_, let errorMessage), CommonError.unknownException(let errorMessage) {
            displayError = (true, errorMessage)
            
        } catch {
            displayError = (true, error.localizedDescription)
            throw error
        }
    }
    
    func getDefaultPromotionDetailsAndEnrollmentStatus(contactId: String, devMode: Bool = false) async throws {
        enrollmentStatusApiState = .loading
        if defaultPromotionInfo != nil {
            await isEnrolledForDefaultPromotion(contactId: contactId, devMode: devMode)
            return
        }
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id, IsReferralPromotion, PromotionCode, Name, Description, ImageUrl, PromotionPageUrl  FROM Promotion Where PromotionCode= '\(promotionCode)'"
            let promotion = try await forceClient.SOQL(type: ReferralPromotionObject.self, for: query)
            defaultPromotionInfo = promotion.records.first
            if defaultPromotionInfo?.promotionCode != nil {
                await isEnrolledForDefaultPromotion(contactId: contactId, devMode: devMode)
            } else {
                displayError = (true, StringConstants.Referrals.genericError)
                enrollmentStatusApiState = .loaded
                promotionScreenType = .promotionError
            }
            
        } catch {
            Logger.error(error.localizedDescription)
            enrollmentStatusApiState = .failed(error)
            promotionScreenType = .promotionError
        }
    }
    
    func isEnrolledForDefaultPromotion(contactId: String, devMode: Bool = false) async {
        if let isEnrolled =  UserDefaults.standard.value(forKey: "isEnrolledForDefaultPromotion") as? Bool {
            if isEnrolled &&  !devMode {
                enrollmentStatusApiState = .loaded
                promotionScreenType = .referFriend
                return
            }
        }
        do {
            // swiftlint:disable:next line_length
            let query = "SELECT Id, Name, PromotionId, LoyaltyProgramMemberId, LoyaltyProgramMember.ContactId FROM LoyaltyProgramMbrPromotion where LoyaltyProgramMember.ContactId='\(contactId)' AND Promotion.PromotionCode='\(promotionCode)'"
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            UserDefaults.standard.setValue(!queryResult.records.isEmpty, forKey: "isEnrolledForDefaultPromotion")
            enrollmentStatusApiState = .loaded
            promotionScreenType =  queryResult.records.isEmpty ? .joinReferralPromotion : .referFriend
        } catch {
            Logger.error(error.localizedDescription)
            enrollmentStatusApiState = .failed(error)
            promotionScreenType = .promotionError
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
                self.referralCode = output.promotionReferralCode.components(separatedBy: "-").first ?? ""
                self.referralMembershipNumber = output.membershipNumber
                UserDefaults.standard.setValue(true, forKey: "isEnrolledForDefaultPromotion")
                promotionScreenType = .referFriend
            } else {
                // status is not `Processed`, if `Pending` should
                Logger.debug("The enrollment status is: \(output.transactionJournals.first?.status ?? "NOTFOUND")")
                promotionScreenType = .promotionError
                displayError = (true, StringConstants.Referrals.enrollmentError)
            }
        } catch {
            Logger.error("Referral Enrollment Error: \(error.localizedDescription)")
            promotionScreenType = .promotionError
            displayError = (true, StringConstants.Referrals.enrollmentError)
        }
    }
    
    private func emailStringToArray(emailString: String) -> [String] {
        return emailString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    private func getReferralCode(for membershipNumber: String) async throws -> String? {
        if !referralCode.isEmpty {
            return referralCode
        }
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
