//
//  ModelClassTests.swift
//  
//
//  Created by Anandhakrishnan Kanagaraj on 05/05/23.
//

import XCTest
@testable import LoyaltyMobileSDK

final class ModelClassTests: XCTestCase {
    
    func testvoucherModel() throws {
        let voucherModel = VoucherModel(id: "000001",
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
        XCTAssertEqual(voucherModel.expirationDate, "05 Jan 2023")
    }
    
    func testPromotionModel() throws {
        let promotion = PromotionResult(
            fulfillmentAction: "CREDIT_POINTS",
            promotionEnrollmentRqr: false,
            memberEligibilityCategory: "Eligible",
            promotionImageURL: "https://unsplash.com/photos/sTa-fO_VM4k/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjc4NzI2MDcx&force=true&w=640",
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
        XCTAssertEqual(promotion.loyaltyPromotionType, "STANDARD")
    }
    
    func testTransactionModel() throws {
        let transactionJournal = TransactionJournal(activityDate: "10 November 2022",
                                                  additionalTransactionJournalAttributes: [AdditionalTransactionJournalAttribute(fieldName: "fieldName",
                                                                                                                                 value: "value")],
                                                  journalSubTypeName: "subtype",
                                                  journalTypeName: "Acceral",
                                                  pointsChange: [PointsChange(changeInPoints: 100.0, loyaltyMemberCurrency: "Reward Points")],
                                                  id: "0001",
                                                  transactionJournalNumber: "",
                                                  productCategoryName: "",
                                                  productName: "",
                                                  transactionAmount: "")
        XCTAssertEqual(transactionJournal.activityDate, "10 November 2022")
        
        let transactionModel = TransactionModel(message: "success",
                                                status: true,
                                                transactionJournalCount: 1,
                                                externalTransactionNumber: "001",
                                                transactionJournals: [transactionJournal])
        XCTAssertEqual(transactionModel.message, "success")
    }
    
    func testBenefitModel() throws {
        let benefitModel = BenefitModel(id: "0ji4x0000008REdAAM",
                                        benefitName: "Extended Returns (7 Days)",
                                        benefitTypeID: "0jh4x0000008REQAA2",
                                        benefitTypeName: "Extended Returns",
                                        createdRecordID: "001",
                                        createdRecordName: "Return",
                                        description: "description",
                                        endDate: "10 November 2022",
                                        isActive: true,
                                        memberBenefitStatus: "active",
                                        startDate: "9 November 2022")
        XCTAssertEqual(benefitModel.id, "0ji4x0000008REdAAM")
        
        let benefits = Benefits(memberBenefits: [benefitModel])
        XCTAssertTrue(benefits.memberBenefits.count == 1)
    }
    
    func testURLQueryElements() {
        let urlElements = [URLQueryItem(name: "token", value: "test123")]
        XCTAssertEqual(urlElements["token"], "test123")
    }
}
