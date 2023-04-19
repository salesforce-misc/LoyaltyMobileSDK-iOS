//
//  MockNetworkManager.swift
//  
//
//  Created by Anandhakrishnan Kanagaraj on 30/03/23.
//

@testable import LoyaltyMobileSDK
import XCTest

class MockNetworkManager: NetworkManagerProtocol {
    public var statusCode = 200
    
    func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode != 401 else {
            throw CommonError.authenticationNeeded
        }
    }
    
    static let sharedMock = MockNetworkManager()
    
    func fetch<T>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T where T : Decodable {
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
