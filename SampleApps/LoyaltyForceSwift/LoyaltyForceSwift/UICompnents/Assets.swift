//
//  Assets.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/24/22.
//

import Foundation
import SwiftUI

struct Assets {
    
    static func getBenefitsLogo(for type: String) -> Image {
        
        switch type {
        case "Free Shipping":
            return Image("ic-benefit-free-shipping")
        case "Extended Return":
            return Image("ic-benefit-extended-return")
        case "Free Sample":
            return Image("ic-benefit-free-sample")
        case "Free Subscription":
            return Image("ic-benefit-free-subscription")
        case "Tier Exclusive Offer":
            return Image("ic-benefit-tier-exclusive-offer")
        case "Support":
            return Image("ic-benefit-support")
        case "Complimentary Vouchers":
            return Image("ic-benefit-complimentary-vouchers")
        default:
            return Image("ic-benefit-default")
        }
    }
    
    static func getTransactionsLogo(for type: String) -> Image {
        
        switch type {
        case "Purchase":
            return Image("ic-tranaction-purchase")
        case "Redemption":
            return Image("ic-tranaction-redemption")
        case "Member Referral":
            return Image("ic-tranaction-member-referral")
        case "Voucher":
            return Image("ic-tranaction-voucher")
        case "Social Media Activity":
            return Image("ic-tranaction-social-media-activity")
        case "Enrollment":
            return Image("ic-tranaction-enrollment")
        default:
            return Image("ic-transaction-default")
        }
    }
}
