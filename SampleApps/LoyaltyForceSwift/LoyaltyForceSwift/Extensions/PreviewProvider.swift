//
//  PreviewProvider.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/21/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

@MainActor
class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    let member = MemberModel(firstName: "Julia",
                             lastName: "Green",
                             email: "julia.green@gmail.com",
                             mobileNumber: "5556781234",
                             joinEmailList: true,
                             dateCreated: Date(),
                             enrollmentDetails: EnrollmentDetails(loyaltyProgramMemberId: "0lM4x000000LECA",
                                                                  loyaltyProgramName: "NTO Insider",
                                                                  membershipNumber: "24345671"))
    
    /*
     [
         {
             "loyaltyPromotionType": "STANDARD",
             "maximumPromotionRewardValue": 0,
             "totalPromotionRewardPointsVal": 0,
             "loyaltyProgramCurrency": "0lc4x000000L1bmAAC",
             "memberEligibilityCategory": "Eligible",
             "promotionEnrollmentRqr": false,
             "fulfillmentAction": "CREDIT_POINTS",
             "promotionName": "Anniversary promotion",
             "promotionId": "0c84x000000CoNhAAK",
             "startDate": "2020-01-01",
             "description": "Double point promotion on member purchases on their anniversary"
         },
         {
             "loyaltyPromotionType": "CUMULATIVE",
             "maximumPromotionRewardValue": 0,
             "totalPromotionRewardPointsVal": 200,
             "loyaltyProgramCurrency": "0lc4x000000L1bmAAC",
             "memberEligibilityCategory": "Eligible",
             "promotionEnrollmentRqr": false,
             "fulfillmentAction": "CREDIT_POINTS",
             "promotionName": "Referral Promotions",
             "promotionId": "0c84x000000CoNiAAK",
             "startDate": "2021-01-02",
             "description": "Additional points for member referral"
         },
         {
             "promEnrollmentStartDate": "2022-11-01",
             "memberEligibilityCategory": "EligibleButNotEnrolled",
             "promotionEnrollmentEndDate": "2022-11-30",
             "promotionEnrollmentRqr": true,
             "promotionName": "Newyear Promotion",
             "promotionId": "0c84x000000CtzRAAS",
             "startDate": "2022-11-01",
             "description": "New Year Promotion Premium - Ineligible"
         },
         {
             "promEnrollmentStartDate": "2022-11-01",
             "memberEligibilityCategory": "Ineligible",
             "promotionEnrollmentEndDate": "2022-11-30",
             "promotionEnrollmentRqr": true,
             "promotionName": "New Year Promotion Premium",
             "promotionId": "0c84x000000CtzWAAS",
             "startDate": "2022-11-01"
         }
     ]
     */
    let promotion = PromotionResult(id: "0c84x000000CtzRAAS",
                                    loyaltyPromotionType: "STANDARD",
                                    maximumPromotionRewardValue: 0,
                                    totalPromotionRewardPointsVal: 0,
                                    loyaltyProgramCurrency: nil,
                                    memberEligibilityCategory: "EligibleButNotEnrolled",
                                    promotionEnrollmentRqr: true,
                                    fulfillmentAction: nil,
                                    promotionName: "New Year Promotion",
                                    startDate: "2022-11-01",
                                    endDate: "2023-01-31",
                                    description: "New Year Promotion Premium",
                                    promEnrollmentStartDate: "2022-11-01",
                                    promotionEnrollmentEndDate: "2022-11-30",
                                    imageName: "promotion2")
    let rootVM = AppRootViewModel()
    let benefitVM = BenefitViewModel()
    let promotionVM = PromotionViewModel()
    
    private init() {
        setMember(member: member)
    }
    
    func setMember(member: MemberModel) {
        self.rootVM.member = member
    }
}
