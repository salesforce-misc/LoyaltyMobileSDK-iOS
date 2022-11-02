//
//  LoyaltyAPIManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/15/22.
//
// https://salesforce.quip.com/3NUAATucFfLU#temp:C:aJadb5bff3175a74eba9461c7d9a

import Foundation

public class LoyaltyAPIManager {
    
    public static let shared = LoyaltyAPIManager()
    
    // TODO: move to a app config or other places
    private let loyaltyProgramName = "NTO Insider"
    
    private init() {}
    
    public enum Resource {
        case individualEnrollment(programName: String)
        case getMemberBenefits(memberId: String)
        case getMemberProfile(programName: String)
        case getTransactions(programName: String)
        case getPromotions(programName: String, programProcessName: String)
        case redeemPoints(programName: String, programProcessName: String)
    }
    
    public func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .individualEnrollment(let programName):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/individual-member-enrollments")
        case .getMemberBenefits(let memberId):
            return ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits")
        case .getMemberProfile(let programName):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/members")
        case .getTransactions(let programName):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/transaction-history") // ?page=1 Will deal with it later
        case .getPromotions(let programName, let programProcessName):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/\(programProcessName)")
        case .redeemPoints(let programName, let programProcessName):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/\(programProcessName)")
        }
    }
    
    /// Get Member Benefits - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    /// - Returns: An ``BenefitModel`` array
    public func getMemberBenefits(for memberId: String, devMode: Bool = false) async throws -> [BenefitModel] {
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: Benefits.self, file: "Benefits")
                return result.memberBenefits
            }
            let path = getPath(for: .getMemberBenefits(memberId: memberId))
            let request = try ForceRequest.create(method: "GET", path: path)
            let result = try await ForceClient.shared.fetch(type: Benefits.self, with: request)
            return result.memberBenefits
        } catch {
            throw error
        }
    }
    
    /// Use public func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T>
    public func getBenefit(by benefitIds: [String]) async throws -> [LoyaltyQueryModels.Benefit] {
        do {
            let ids = benefitIds.map { "'" + $0 + "'" }.joined(separator: ",")
            let query = "SELECT Id, Description FROM Benefit WHERE Id in ('\(ids)')"
            let queryResult = try await ForceClient.shared.SOQL(type: LoyaltyQueryModels.Benefit.self, for: query)
            return queryResult.records
        } catch {
            throw error
        }
    }

    /// Use public func SOQL(for query: String) async throws -> QueryResult<Record>
    public func getBenefitRecord(by benefitIds: [String]) async throws -> [Record] {
        do {
            let ids = benefitIds.map { "'" + $0 + "'" }.joined(separator: ",")
            let query = "SELECT Id, Description FROM Benefit WHERE Id in (\(ids))"
            let queryResult = try await ForceClient.shared.SOQL(for: query)
            return queryResult.records
        } catch {
            throw error
        }
    }
    
    /// Get Member Profile - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    ///   - programName: The loytalty program name
    /// - Returns: An ``ProfileModel`` instance
    public func getMemberProfile(for memberId: String, programName: String) async throws -> ProfileModel {
        do {
            let path = getPath(for: .getMemberProfile(programName: programName))
            let queryItems = ["memberId": "\(memberId)"]
            let request = try ForceRequest.create(method: "GET", path: path, queryItems: queryItems)
            return try await ForceClient.shared.fetch(type: ProfileModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    private func randomString(of length: Int) -> String {
         let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         var s = ""
         for _ in 0 ..< length {
             s.append(letters.randomElement()!)
         }
         return s
    }
    
    public func postEnrollment(firstName: String, lastName: String, email: String) async throws -> EnrollmentOutputModel {
        
        let currentDate = Date()
        let membershipNumber = randomString(of: 8)
        let attributes: [String: String] = [:]
        let additionalValues = AdditionalFieldValues(attributes: attributes)
        let contactDetails = AssociatedContactDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            allowDuplicateRecords: false,
            additionalContactFieldValues: additionalValues)
        
        let enrollment = EnrollmentModel(
            enrollmentDate: currentDate,
            membershipNumber: membershipNumber,
            associatedContactDetails: contactDetails,
            memberStatus: "Active",
            referredBy: nil,
            createTransactionJournals: true,
            transactionJournalStatementFrequency: "Monthly",
            transactionJournalStatementMethod: "Mail",
            enrollmentChannel: "Email",
            canReceivePromotions: true,
            canReceivePartnerPromotions: true,
            membershipEndDate: nil,
            relatedCorporate​MembershipNumber: nil,
            additionalMemberFieldValues: additionalValues)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.forceFormatter())
            let requestBody = try encoder.encode(enrollment)
            if let requestJson = String(data: requestBody, encoding: .utf8) {
                print(requestJson)
            }
            let path = getPath(for: .individualEnrollment(programName: loyaltyProgramName))
            let request = try ForceRequest.create(method: "POST", path: path, body: requestBody)
            return try await ForceClient.shared.fetch(type: EnrollmentOutputModel.self, with: request)
            
        } catch {
            throw error
        }
        
    }
    
    func getPromotions(for memberId: String) async throws -> PromotionModel {
        do {
            let result = try ForceClient.shared.fetchLocalJson(type: PromotionModel.self, file: "Promotions")
            return result
        } catch {
            throw error
        }
    }
    
    func getTransactions(for memberId: String) async throws -> TransactionModel {
        do {
            let result = try ForceClient.shared.fetchLocalJson(type: TransactionModel.self, file: "Transactions")
            return result
        } catch {
            throw error
        }
    }
}
