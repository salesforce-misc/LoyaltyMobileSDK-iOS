/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// Extension to check if a Data object is valid JSON
extension Data {
    var isValidJSON: Bool {
        do {
            try JSONSerialization.jsonObject(with: self)
            return true
        } catch {
            return false
        }
    }
}
