//
//  File.swift
//  
//
//  Created by Leon Qi on 12/18/23.
//

import Foundation

// MARK: - ReferralEnrollmentInputModel
public struct ReferralEnrollmentInputModel: Codable {
    let associatedPersonAccountDetails: AssociatedPersonAccountDetails?
    let memberStatus, transactionJournalStatementFrequency, transactionJournalStatementMethod, enrollmentChannel: String?
    let additionalMemberFieldValues: AdditionalMemberFieldValues?
}

// MARK: - AdditionalMemberFieldValues
public struct AdditionalMemberFieldValues: Codable {
    let attributes: AdditionalMemberFieldValuesAttributes?
}

// MARK: - AdditionalMemberFieldValuesAttributes
public struct AdditionalMemberFieldValuesAttributes: Codable {
}

// MARK: - AssociatedPersonAccountDetails
public struct AssociatedPersonAccountDetails: Codable {
    let firstName, lastName, email, allowDuplicateRecords: String
    let additionalPersonAccountFieldValues: AdditionalPersonAccountFieldValues?
}

// MARK: - AdditionalPersonAccountFieldValues
public struct AdditionalPersonAccountFieldValues: Codable {
    let attributes: AdditionalPersonAccountFieldValuesAttributes?
}

// MARK: - AdditionalPersonAccountFieldValuesAttributes
public struct AdditionalPersonAccountFieldValuesAttributes: Codable {
}
