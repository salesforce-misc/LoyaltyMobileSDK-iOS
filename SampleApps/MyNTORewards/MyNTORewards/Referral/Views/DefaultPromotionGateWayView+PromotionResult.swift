//
//  MyReferralsView+PromotionResult.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 15/02/24.
//

import Foundation
import LoyaltyMobileSDK

extension DefaultPromotionGateWayView {
    func getPromotionData(membershipNumber: String) -> PromotionResult? {
        if let promotions = LocalFileManager.instance.getData(type: [PromotionResult].self,
                                                              id: membershipNumber,
                                                              folderName: AppSettings.cacheFolders.promotions),
           let defaultPromotion = promotions.first(where: {$0.id == AppSettings.Defaults.referralPromotionId}) {
            
            return defaultPromotion
        }
        return nil
    }
}
