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
//    let member = MemberModel(firstName: "Julia",
//                             lastName: "Green",
//                             email: "julia.green@gmail.com",
//                             mobileNumber: "5556781234",
//                             joinEmailList: true,
//                             dateCreated: Date(),
//                             enrollmentDetails: EnrollmentDetails(loyaltyProgramMemberId: "0lM4x000000LECA",
//                                                                  loyaltyProgramName: "NTO Insider",
//                                                                  membershipNumber: "24345671"))
    let member = CommunityMemberModel(firstName: "Julia",
                                      lastName: "Green",
                                      email: "julia.green@gmail.com",
                                      loyaltyProgramMemberId: "0lM4x000000LECA",
                                      loyaltyProgramName: "NTO Insider",
                                      membershipNumber: "24345671")
    
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
    
    let promotion = PromotionResult(fulfillmentAction: "CREDIT_POINTS",
                                    promotionEnrollmentRqr: false,
                                    memberEligibilityCategory: "Eligible",
                                    promotionImageURL: "https://salesforce.widen.net/content/f1h2462zr8/png/AdobeStock_328036344.jpeg",
                                    loyaltyPromotionType: "STANDARD",
                                    totalPromotionRewardPointsVal: 250,
                                    promotionName: "Mountain Biking Bonanza",
                                    id: "0c8RO0000000QbRYAU",
                                    startDate: "2023-01-01",
                                    endDate: "2023-12-31",
                                    loyaltyProgramCurrency: "0lcRO00000000BVYA",
                                    description: "Promote sustainable travel alternatives and earn rewards by joining us in the Mountain Biking Bonanza event",
                                    promotionEnrollmentEndDate: "end",
                                    promEnrollmentStartDate: "start")
    
    // let currency = TransactionCurrency(value: 100, name: "Reward Points")
    let transactions = [
        TransactionJournal(activityDate: "10 November 2022",
                           additionalTransactionJournalAttributes: [],
                           journalSubTypeName: "subtype",
                           journalTypeName: "Acceral",
                           pointsChange: [PointsChange(changeInPoints: 100.0, loyaltyMemberCurrency: "Reward Points")],
                           id: "0001",
                           transactionJournalNumber: "",
                           productCategoryName: "",
                           productName: "",
                           transactionAmount: ""),
        TransactionJournal(activityDate: "12 November 2022",
                           additionalTransactionJournalAttributes: [],
                           journalSubTypeName: "subtype",
                           journalTypeName: "Manual Points Adjustment",
                           pointsChange: [PointsChange(changeInPoints: 300.0, loyaltyMemberCurrency: "Reward Points")],
                           id: "0001",
                           transactionJournalNumber: "",
                           productCategoryName: "",
                           productName: "",
                           transactionAmount: "")
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
								redeemedValue: 0.0,
								remainingValue: 0.0,
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
								redeemedValue: 0.0,
								remainingValue: 0.0,
								currencyIsoCode: "",
								isVoucherDefinitionActive: false,
								isVoucherPartiallyRedeemable: false,
								product: "",
								productId: "",
								productCategoryId: "",
								productCategory: "",
								promotionName: "",
								promotionId: "")
	
	let voucherTitles = [VoucherTitle(id: "1", title: "Ironman Voucher"),
						 VoucherTitle(id: "2", title: "Winter Jacket")]
    
    let checkoutVouchersCode = ["Trendy wear 25 off", "Trendy wear 50 off", "Trendy wear 15 off", "Trendy wear 75 off", "Trendy wear 100 off"]
	
	let processedReceipt = ProcessedReceipt(receiptSfdcId: "sdgd3434345",
											totalAmount: "$154.0",
											storeName: "Costco",
											storeAddress: "San Jose",
											receiptNumber: "R-US-001",
											receiptDate: Date(),
											lineItem: [ProcessedReceiptItem(quantity: "4",
																			productName: "Nike Shoes",
																			price: "$20",
																			lineItemPrice: "$30",
                                                                            isEligible: true)], 
                                                                            confidenceStatus: .success)
	let eligibleItems = [ProcessedReceiptItem(quantity: "4",
											  productName: "Nike Shoes",
											  price: "$20",
											  lineItemPrice: "$30",
											  isEligible: true),
						 ProcessedReceiptItem(quantity: "4",
											  productName: "Nike Shoes",
											  price: "$20",
											  lineItemPrice: "$30",
											  isEligible: true)
	]
	let ineligibleItems = [ProcessedReceiptItem(quantity: "4",
												productName: "Nike Shoes",
												price: "$20",
												lineItemPrice: "$30",
												isEligible: false),
						   ProcessedReceiptItem(quantity: "4",
												productName: "Nike Shoes",
												price: "$20",
												lineItemPrice: "$30",
												isEligible: false)
	]
    
    let activeGame = GameDefinition(name: "Barney and Clyde Style Promotion",
                                    gameDefinitionId: "1",
                                    description: "",
                                    type: .spinaWheel,
                                    startDate: Date(),
                                    endDate: nil,
                                    timeoutDuration: 10,
                                    status: .active,
                                    gameRewards: [],
                                    participantGameRewards: [])
    
    let expiredGame = GameDefinition(name: "Barney and Clyde Style Promotion",
                                      gameDefinitionId: "2",
                                      description: "",
                                      type: .spinaWheel,
                                      startDate: Date(),
                                      endDate: nil,
                                      timeoutDuration: 10,
                                      status: .expired,
                                      gameRewards: [],
                                      participantGameRewards: [])

    let rootVM = AppRootViewModel()
    let benefitVM = BenefitViewModel()
    let promotionVM = PromotionViewModel()
    let profileVM = ProfileViewModel()
    let voucherVM = VoucherViewModel()
	let imageVM = ImageViewModel()
    let transactionVM = TransactionViewModel()
	let orderDetailsVM = OrderDetailsViewModel()
    let connectedAppVM = ConnectedAppsViewModel<ForceConnectedAppKeychainManager>()
    let productVM = ProductViewModel()
    let processedReceiptVM = ProcessedReceiptViewModel()
    let camVM = CameraViewModel()
    let routerPath = RouterPath()
    let receiptVM = ReceiptViewModel()
    let receiptListVM = ReceiptListViewModel()
    
    private init() {
        setMember(member: member)
        promotionVM.promotions = [promotion]
		processedReceiptVM.processedReceipt = processedReceipt
		processedReceiptVM.eligibleItems = eligibleItems
		processedReceiptVM.inEligibleItems = ineligibleItems
    }
    
    func setMember(member: CommunityMemberModel) {
        self.rootVM.member = member
    }
}
