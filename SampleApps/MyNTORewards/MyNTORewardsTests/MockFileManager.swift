//
//  MockFileManager.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 03/03/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

class MockAuthenticator: Authenticator {
    func getAccessToken() -> String? {
        return "Access1234"
    }
    
    var accessToken: String?
    
    func grantAccessToken() async throws -> String {
        return "Access1234"
    }
    
    static let sharedMock = MockAuthenticator()
}

class MockFileManager: FileManagerProtocol {
    
    static let mockInstance = MockFileManager()
    
    var fileData: [String: Codable] = [:]
    var imageData: [String: UIImage] = [:]
    
    public func saveData<T: Codable>(item: T, id: String, folderName: String? = nil, expiry: Expiry = .never) {
		fileData.updateValue(item, forKey: folderName ?? id)
		Logger.debug("\n\nData saved in Mock File Manager: \n\(fileData)")
    }
    
    func getData<T: Codable>(type: T.Type, id: String, folderName: String?) -> T? {
		Logger.debug("\n\nData retrieved from Mock File Manager: \n\(fileData)")
		return fileData[folderName ?? id] as? T
    }
    
    func removeData<T>(type: T.Type, id: String, folderName: String?){
		fileData.removeValue(forKey: folderName ?? id)
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String?, expiry: Expiry) {
        imageData.updateValue(image, forKey: imageName)
    }
    
    func getImage(imageName: String, folderName: String?) -> UIImage? {
        return imageData[imageName]
    }
    
    func clear() {
        fileData.removeAll()
        imageData.removeAll()
    }
}
