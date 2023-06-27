/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import XCTest
@testable import LoyaltyMobileSDK

extension XCTestCase {
        
    static func load(resource: String, withExtension: String = "json", inBundle: Bundle? = nil) throws -> Data {
        let bundle = inBundle ?? Bundle.module
        guard let url = bundle.url(forResource: resource, withExtension: withExtension) else {
            throw URLError(.fileDoesNotExist, userInfo: [NSURLErrorFailingURLErrorKey: "\(resource).\(withExtension)"])
        }
        return try Data(contentsOf: url)
    }
}
