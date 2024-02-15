//
//  MyReferralsView+PromotionResult.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 15/02/24.
//

import Foundation
import LoyaltyMobileSDK

extension MyReferralsView {
    func getPromotionData(membershipNumber: String) -> PromotionResult? {
        if let promotions = LocalFileManager.instance.getData(type: [PromotionResult].self,
                                                              id: membershipNumber,
                                                              folderName: AppSettings.cacheFolders.promotions),
           let defaultPromotion = promotions.first(where: {$0.id == AppSettings.Defaults.defaultReferralPromotionId}) {
            
            return defaultPromotion
        }
        return nil
    }
    
    func getAsyncPromotionData(membershipNumber: String) async -> PromotionResult? {
    if let promotions = LocalFileManager.instance.getData(type: [PromotionResult].self,
                                                          id: membershipNumber,
                                                          folderName: AppSettings.cacheFolders.promotions),
           let defaultPromotion = promotions.first(where: {$0.id == AppSettings.Defaults.defaultReferralPromotionId}) {
            
            return defaultPromotion
        } else {
            do {
                _ = try await viewModel.getDefaultPromotionDetails()
                let promotion = PromotionResult(fulfillmentAction: "",
                                                promotionEnrollmentRqr: false,
                                                memberEligibilityCategory: "",
                                                promotionImageURL: viewModel.defaultReferralPromotion?.promotionImageUrl,
                                                loyaltyPromotionType: "STANDARD",
                                                totalPromotionRewardPointsVal: nil,
                                                promotionName: viewModel.defaultReferralPromotion?.name ?? "",
                                                id: viewModel.defaultReferralPromotion?.id ?? "",
                                                startDate: "",
                                                endDate: "",
                                                loyaltyProgramCurrency: "0lcRO00000000BVYA",
                                                description: viewModel.defaultReferralPromotion?.description ?? "",
                                                promotionEnrollmentEndDate: "end",
                                                promEnrollmentStartDate: "start")
                return promotion
                
            } catch {
                return nil
            }
        }
    }
}
