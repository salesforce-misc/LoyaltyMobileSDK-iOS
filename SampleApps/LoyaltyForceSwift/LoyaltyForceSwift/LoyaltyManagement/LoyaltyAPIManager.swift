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
            return ForceConfig.path(for: "connect/loyalty-programs/\(programName)/individual-member-enrollments")
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
    public func getMemberBenefits(for memberId: String) async throws -> [BenefitModel] {
        do {
            let path = getPath(for: .getMemberBenefits(memberId: memberId))
            let request = try ForceRequest.create(method: "GET", path: path)
            let result = try await ForceClient.shared.fetch(type: Benefits.self, with: request)
            return result.memberBenefits
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
}
