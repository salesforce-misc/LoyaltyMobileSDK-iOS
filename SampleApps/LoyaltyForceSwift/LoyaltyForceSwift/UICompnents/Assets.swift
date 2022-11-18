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
            return Image("ic-transaction-purchase")
        case "Redemption":
            return Image("ic-transaction-redemption")
        case "Member Referral":
            return Image("ic-transaction-member-referral")
        case "Voucher":
            return Image("ic-transaction-voucher")
        case "Social Media Activity":
            return Image("ic-transaction-social-media-activity")
        case "Enrollment":
            return Image("ic-transaction-enrollment")
        default:
            return Image("ic-transaction-default")
        }
    }
    
    static func getTierColor(tierName: String) -> Color {
        
        switch tierName.lowercased() {
        case "silver":
            return Color.tierColor.silver
        case "gold":
            return Color.tierColor.gold
        case "bronze":
            return Color.tierColor.bronze
        case "platinum":
            return Color.tierColor.platinum
        case "ruby":
            return Color.tierColor.ruby
        default:
            return Color.white
        }
    }
}
