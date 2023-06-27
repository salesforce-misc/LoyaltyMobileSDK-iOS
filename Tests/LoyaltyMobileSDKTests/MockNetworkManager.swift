/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@testable import LoyaltyMobileSDK
import XCTest

class MockNetworkManager: NetworkManagerProtocol {
    public var statusCode = 200
    
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let httpResponse = output.response as? HTTPURLResponse else {
            Logger.error(CommonError.requestFailed(message: "Invalid response").description)
            throw CommonError.requestFailed(message: "Invalid response")
        }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            Logger.error(CommonError.authenticationNeeded.description)
            throw CommonError.authenticationNeeded
        case 403:
            Logger.error(CommonError.functionalityNotEnabled.description)
            throw CommonError.functionalityNotEnabled
        default:
            let errorMessage = "HTTP response status code \(httpResponse.statusCode)"
            Logger.error(CommonError.responseUnsuccessful(message: errorMessage).description)
            Logger.debug(httpResponse.description)
            throw CommonError.responseUnsuccessful(message: errorMessage)
        }
    }
    
    static let sharedMock = MockNetworkManager()
    
    func fetch<T>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T where T: Decodable {
        let data = try await responseData(type: T.Type.self)
        let mockSession = URLSession.mock(responseBody: data, statusCode: statusCode)
        let output = try await mockSession.data(for: request)
        try handleUnauthResponse(output: output)
        statusCode = 200
        return try JSONDecoder().decode(type, from: output.0)
    }
    
    func responseData<T>(type: T.Type) async throws -> Data {
        if type.self == ProfileModel.Type.self {
            return try XCTestCase.load(resource: "Profile")
        } else if type.self == Benefits.Type.self {
            return try XCTestCase.load(resource: "Benefits")
        } else if type.self == EnrollmentOutputModel.Type.self {
            return try XCTestCase.load(resource: "Enrollment")
        } else if type.self == EnrollPromotionOutputModel.Type.self {
            return try XCTestCase.load(resource: "EnrollmentPromotion")
        } else if type.self == UnenrollPromotionResponseModel.Type.self {
            return try XCTestCase.load(resource: "UnenrollmentPromotion")
        } else if type.self == PromotionModel.Type.self {
            return try XCTestCase.load(resource: "Promotions")
        } else if type.self == TransactionModel.Type.self {
            return try XCTestCase.load(resource: "Transactions")
        } else if type.self == VouchersResponse.Type.self {
            return try XCTestCase.load(resource: "Vouchers")
        }
        
        return Data()
    }
}
