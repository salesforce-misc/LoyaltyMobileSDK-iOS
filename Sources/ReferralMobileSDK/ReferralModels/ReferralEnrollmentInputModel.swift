//
//  File.swift
//  
//
//  Created by Leon Qi on 12/18/23.
//

import Foundation

// MARK: - ReferralEnrollmentInputModel
public struct ReferralEnrollmentInputModel: Codable {
    public let associatedPersonAccountDetails: AssociatedPersonAccountDetails?
    public let memberStatus, transactionJournalStatementFrequency, transactionJournalStatementMethod, enrollmentChannel: String?
    public let additionalMemberFieldValues: AdditionalMemberFieldValues?
}

// MARK: - AdditionalMemberFieldValues
public struct AdditionalMemberFieldValues: Codable {
    public let attributes: AdditionalMemberFieldValuesAttributes?
}

// MARK: - AdditionalMemberFieldValuesAttributes
public struct AdditionalMemberFieldValuesAttributes: Codable {
}

// MARK: - AssociatedPersonAccountDetails
public struct AssociatedPersonAccountDetails: Codable {
    public let firstName, lastName, email, allowDuplicateRecords: String
    public let additionalPersonAccountFieldValues: AdditionalPersonAccountFieldValues?
}

// MARK: - AdditionalPersonAccountFieldValues
public struct AdditionalPersonAccountFieldValues: Codable {
    public let attributes: AdditionalPersonAccountFieldValuesAttributes?
}

// MARK: - AdditionalPersonAccountFieldValuesAttributes
public struct AdditionalPersonAccountFieldValuesAttributes: Codable {
}
