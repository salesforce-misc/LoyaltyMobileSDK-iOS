//
//  PromotionModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/20/22.
//

import Foundation

// MARK: - PromotionModel
public struct PromotionModel: Codable {
    public let message: String?
    public let outputParameters: PromotionModelOutputParameters
    public let simulationDetails: SimulationDetails
    public let status: Bool
}

// MARK: - PromotionModelOutputParameters
public struct PromotionModelOutputParameters: Codable {
    public let outputParameters: PromotionOutputsOutputParameters
}

// MARK: - OutputParametersOutputParameters
public struct PromotionOutputsOutputParameters: Codable {
    public let results: [PromotionResult]
}

// MARK: - PromotionResult
public struct PromotionResult: Identifiable, Codable {
    public let id: String
    public let loyaltyPromotionType: String?
    public let maximumPromotionRewardValue, totalPromotionRewardPointsVal: Int?
    public let loyaltyProgramCurrency: String?
    public let memberEligibilityCategory: String
    public let promotionEnrollmentRqr: Bool
    public let fulfillmentAction: String?
    public let promotionName: String
    public let startDate: String
    public let endDate: String?
    public let description: String?
    public let promEnrollmentStartDate, promotionEnrollmentEndDate: String?
    public let imageUrl: String?
    
    public let promoImages: [String: String] = [
        "0c84x000000CoNkAAK":    "https://unsplash.com/photos/_3Q3tsJ01nc/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MTV8fHdvbWVuJTIwY2xvdGhlc3xlbnwwfHx8fDE2Njk5MTg4MzI&force=true&w=640",
        "0c84x000000CoNlAAK":    "https://unsplash.com/photos/uRo3NUUq-GM/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8M3x8aXJvbiUyMG1hbnxlbnwwfHx8fDE2Njk4NDM2Njg&force=true&w=640",
        "0c84x000000CoNmAAK":    "https://unsplash.com/photos/qW_k6x5OfRc/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8Mzl8fHNob3B8ZW58MHx8fHwxNjY5OTE1MzIx&force=true&w=640",
        "0c84x000000CoNnAAK":    "https://unsplash.com/photos/_0aKQa9gr4s/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MjB8fGhhcHB5fGVufDB8fHx8MTY2OTg1MTk5NA&force=true&w=640",
        "0c84x000000CoNoAAK":    "https://unsplash.com/photos/X0yKdR_F9rM/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MTF8fHNob3B8ZW58MHx8fHwxNjY5OTA0NDcx&force=true&w=640",
        "0c84x000000CoNpAAK":    "https://unsplash.com/photos/FWVMhUa_wbY/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NDd8fGFwcHxlbnwwfHx8fDE2Njk5MTg5NTg&force=true&w=640",
        "0c84x000000CoNqAAK":    "https://unsplash.com/photos/53lXBmTnaWA/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE4Njc3&force=true&w=640",
        "0c84x000000CoNXAA0":    "https://unsplash.com/photos/A0AZf4h5ZZI/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NXx8Z29sZCUyMHN0YXJ8ZW58MHx8fHwxNjY5OTA3MTE3&force=true&w=640",
        "0c84x000000CoNYAA0":    "https://unsplash.com/photos/pQm90mYMnt0/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE4NDk5&force=true&w=640",
        "0c84x000000CoNZAA0":    "https://unsplash.com/photos/NPBnWE1o07I/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OXx8dGhhbmtzZ2l2aW5nfGVufDB8fHx8MTY2OTkwMjkwMA&force=true&w=640",
        "0c84x000000CoNaAAK":    "https://unsplash.com/photos/18N4okmWccM/download?force=true&w=640",
        "0c84x000000CoNbAAK":    "https://unsplash.com/photos/EinarOsPaNo/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE2MTU3&force=true&w=640",
        "0c84x000000CoNcAAK":    "https://unsplash.com/photos/GaprWyIw66o/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NjV8fEh5ZHJhJTIwd2VsbG5lc3N8ZW58MHx8fHwxNjY5OTE5NTIy&force=true&w=640",
        "0c84x000000CoNdAAK":    "https://unsplash.com/photos/3_PaUEEcwMc/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE5NzE5&force=true&w=640",
        "0c84x000000CoNeAAK":    "https://unsplash.com/photos/TS--uNw-JqE/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OXx8d29tZW4lMjBjbG90aGVzfGVufDB8fHx8MTY2OTkxODgzMg&force=true&w=640",
        "0c84x000000CoNfAAK":    "https://unsplash.com/photos/spP6LqxN0-g/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE4ODg3&force=true&w=640",
        "0c84x000000CoNgAAK":    "https://unsplash.com/photos/7qCeFo19r24/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTE5MjA5&force=true&w=640",
        "0c84x000000CoNhAAK":    "https://unsplash.com/photos/j4hsN4l3BM0/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MTV8fGNoZWVyc3xlbnwwfHx8fDE2Njk4NDQ0MzA&force=true&w=640",
        "0c84x000000CoNiAAK":    "https://unsplash.com/photos/yQgR2EVuT3k/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MzV8fGZyaWVuZHNoaXB8ZW58MHx8fHwxNjY5OTE3OTky&force=true&w=640",
        "0c84x000000CoNjAAK":    "https://unsplash.com/photos/WvDYdXDzkhs/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NXx8Zml0bmVzc3xlbnwwfHx8fDE2Njk5MTE0Njc&force=true&w=640",
        "0c84x000000CtzRAAS":    "https://unsplash.com/photos/ocb4ft1qyjA/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY5OTIwMTUx&force=true&w=640",
        "0c84x000000CtzWAAS":    "https://unsplash.com/photos/OUSa9MU4zZc/download?force=true&w=640"
    ]
    
    public init(id: String, loyaltyPromotionType: String?, maximumPromotionRewardValue: Int?, totalPromotionRewardPointsVal: Int?, loyaltyProgramCurrency: String?, memberEligibilityCategory: String, promotionEnrollmentRqr: Bool, fulfillmentAction: String?, promotionName: String, startDate: String, endDate: String?, description: String?, promEnrollmentStartDate: String?, promotionEnrollmentEndDate: String?, imageUrl: String?) {
        self.id = id
        self.loyaltyPromotionType = loyaltyPromotionType
        self.maximumPromotionRewardValue = maximumPromotionRewardValue
        self.totalPromotionRewardPointsVal = totalPromotionRewardPointsVal
        self.loyaltyProgramCurrency = loyaltyProgramCurrency
        self.memberEligibilityCategory = memberEligibilityCategory
        self.promotionEnrollmentRqr = promotionEnrollmentRqr
        self.fulfillmentAction = fulfillmentAction
        self.promotionName = promotionName
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.promEnrollmentStartDate = promEnrollmentStartDate
        self.promotionEnrollmentEndDate = promotionEnrollmentEndDate
        self.imageUrl = imageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "promotionId"
        case loyaltyPromotionType, maximumPromotionRewardValue, totalPromotionRewardPointsVal, loyaltyProgramCurrency, memberEligibilityCategory, promotionEnrollmentRqr, fulfillmentAction, promotionName
        case startDate, endDate
        case description, promEnrollmentStartDate, promotionEnrollmentEndDate
        case imageUrl = "ImageUrl__c"
    }
}

// MARK: - SimulationDetails
public struct SimulationDetails: Codable {
}
