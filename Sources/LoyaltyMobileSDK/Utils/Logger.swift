/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import os.log

/// Logger class to handle logging messages in a standardized way.
public class Logger {
    /// Set up OSLog with the app's bundle identifier, or use a default identifier if not available.
    private static let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.salesforce.loyaltyApp", category: "LoyaltyLogger")

    /// Log an informational message.
    /// - Parameter message: The message to be logged.
    public static func info(_ message: String) {
        os_log(.info, log: log, "%{public}s", message)
    }

    /// Log a debug message.
    /// - Parameter message: The message to be logged.
    public static func debug(_ message: String) {
        os_log(.debug, log: log, "%{public}s", message)
    }

    /// Log an error message.
    /// - Parameter message: The message to be logged.
    public static func error(_ message: String) {
        os_log(.error, log: log, "%{public}s", message)
    }

    /// Log a fault message.
    /// - Parameter message: The message to be logged.
    public static func fault(_ message: String) {
        os_log(.fault, log: log, "%{public}s", message)
    }
}
