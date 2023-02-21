//
//  PreviewProvider.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/21/22.
//

import Foundation
import SwiftUI
import LoyaltyMobileSDK

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
                                    imageUrl: "https://picsum.photos/800")
    
    //let currency = TransactionCurrency(value: 100, name: "Reward Points")
    let transactions = [
        TransactionHistory(id: "0000435",
                           transactionAmount: 500,
                           productDetails: nil,
                           memberCurrency: [TransactionCurrency(value: 500, name: "Reward Points")],
                           activityDate: "20 November 2022",
                           activity: "Purchase"),
        
        TransactionHistory(id: "0000436",
                           transactionAmount: -100,
                           productDetails: nil,
                           memberCurrency: [TransactionCurrency(value: -100, name: "Reward Points")],
                           activityDate: "10 November 2022",
                           activity: "Redemption")
    ]
    
	let voucher1 = VoucherModel(id: "000001",
								voucherDefinition: "Birthday Discount Voucher",
								voucherCode: "84KFFFS",
								voucherImageUrl: "https://picsum.photos/800",
								voucherNumber: "",
								description: "",
								type: "DiscountPercentage",
								discountPercent: 20,
								expirationDate: "05 Jan 2023",
								effectiveDate: "",
								useDate: "",
								attributesUrl: "",
								status: "Issued",
								partnerAccount: "",
								faceValue: nil,
								redeemedValue: "",
								remainingValue: "",
								currencyIsoCode: "",
								isVoucherDefinitionActive: false,
								isVoucherPartiallyRedeemable: false,
								product: "",
								productId: "",
								productCategoryId: "",
								productCategory: "",
								promotionName: "",
								promotionId: "")
	
	let voucher2 = VoucherModel(id: "000002",
								voucherDefinition: "Christmas Discount Voucher",
								voucherCode: "XMAS2022",
								voucherImageUrl: "https://picsum.photos/800",
								voucherNumber: "",
								description: "",
								type: "FixedValue",
								discountPercent: 20,
								expirationDate: "31 Dec 2023",
								effectiveDate: "",
								useDate: "",
								attributesUrl: "",
								status: "Issued",
								partnerAccount: "",
								faceValue: nil,
								redeemedValue: "",
								remainingValue: "",
								currencyIsoCode: "",
								isVoucherDefinitionActive: false,
								isVoucherPartiallyRedeemable: false,
								product: "",
								productId: "",
								productCategoryId: "",
								productCategory: "",
								promotionName: "",
								promotionId: "")
    
    let rootVM = AppRootViewModel()
    let benefitVM = BenefitViewModel()
    let promotionVM = PromotionViewModel()
    let profileVM = ProfileViewModel()
    let voucherVM = VoucherViewModel()
	let imageVM = ImageViewModel()
    
    private init() {
        setMember(member: member)
        promotionVM.promotions = [promotion]
    }
    
    func setMember(member: MemberModel) {
        self.rootVM.member = member
    }
}
