//

import XCTest
@testable import MyNTORewards

enum TestDataError: Error {
    case incorrectData(_ message: String)
}

final class UITestingHelper: XCTestCase {
    static let app = XCUIApplication()
    
    static func isLoggedIn() -> Bool {
        return !app.buttons["login_button"].exists
    }
    
    static func getUserName() throws -> String {
        guard let username = UITestingHelper.getValue(for: "TEST_USERNAME") as? String
        else {
            throw TestDataError.incorrectData("test data error: username")
        }
        return username
    }
    
    static func getPassword() throws -> String {
        guard let password = UITestingHelper.getValue(for: "TEST_PASSWORD") as? String
        else {
            throw TestDataError.incorrectData("test data error: password")
        }
        return password
    }
    
    static func getEmptyPromotionUserName() throws -> String {
        guard let username = UITestingHelper.getValue(for: "TEST_EMPTYPROMOTION_USERNAME") as? String
        else {
            throw TestDataError.incorrectData("test data error: username")
        }
        return username
    }
    
    static func getEmptyPromotionPassword() throws -> String {
        guard let password = UITestingHelper.getValue(for: "TEST_EMPTYPROMOTION_PASSWORD") as? String
        else {
            throw TestDataError.incorrectData("test data error: username")
        }
        return password
    }
    
    private static  func getValue(for key: String) -> Any? {
        return Bundle(for: MyNTORewardsUITests.self).object(forInfoDictionaryKey: key)
    }
}
