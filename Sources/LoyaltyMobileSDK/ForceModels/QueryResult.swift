//
//  QueryResult.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/16/22.
//
// SOQL query result model

import Foundation

public struct QueryResult<T: Decodable>: Decodable {
    
    public let totalSize: Int
    public let isDone: Bool
    public let records: [T]
    public let nextRecordsPath: String?
    
    enum CodingKeys: String, CodingKey {
        case totalSize
        case isDone = "done"
        case records
        case nextRecordsPath = "nextRecordsUrl"
    }
}
