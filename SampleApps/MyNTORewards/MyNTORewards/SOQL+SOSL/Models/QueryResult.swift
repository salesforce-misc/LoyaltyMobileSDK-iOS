/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

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
