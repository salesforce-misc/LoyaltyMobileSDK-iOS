//
//  Color.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/30/22.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let tierColor = TierColor()
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

struct ColorTheme {
    let accent = Color("AccentColor") // #7526E3
    let background = Color("BackgroundColor") // #F7F4FB
    let backgroundPink = Color("BackgroundPinkColor") // #F9F0FF
    let darkBlue = Color("DarkBlueColor") // #4141E7
    let lightBlue = Color("LightBlueColor") // #5B5FC7
    let superLightBlue = Color("SuperLightBlueColor") // #D8E6FE
    let titleColor = Color("TitleColor") // #09101D
    let listSeparatorPink = Color("ListSeparatorColor") // #ECE1F9
    let textInactive = Color("TextInactiveColor") // #747474
    let lightText = Color("TextLightColor") // #181818
    let superLightText = Color("TextSuperLightColor") // #444444
    let lightButton = Color("ButtonLightColor") // #F9F0FF
    let darkButton = Color("ButtonDarkColor") // #7526E3
    let textFieldBackground = Color("TextFieldBackgroundColor") // #F6F2FB
    let textFieldBorder = Color("TextFieldBorderColor") // #AD7BEE
    let voucherCode = Color("VoucherCodeColor") // #04844B
    let voucherBorder = Color("VoucherCodeBorderColor") // #2E844A
    let voucherBackground = Color("VoucherCodeBackgroundColor") // #EBF7E6
    let points = Color("PointsColor") // #2E844A
    let negativePoints = Color("NegativePointsColor") // #BA0517
    let badgeBackground = Color("BadgeTextBackgroundColor") // #FAFAFA
    let memberStatus = Color("GoldColor") // #FCC003
    let progressBarBackground = Color("ProgressBarBackgroundColor") // #E2E2E2
    let tierPoints = Color("TierPointsColor") // #7D7D7D
    let lightBlackText = Color("TextLightBlackColor") // #231F20
    let redeemedButtonText = Color("TextRedeemButtonColor") // #8C4B02
    let redeemedButtonBackground = Color("RedeemedBackgroundColor") // #FBF3E0
    let expiredButtonText = Color("TextExpiredButtonColor") // #5C5C5C
    let expiredBackgroundText = Color("ExpiredBackgroundColor") // #E5E5E5
	let receiptListItemShadowColor = Color("ReceiptListItemShadowColor") // #ABABAB
    let searchBarBackgroundColor = Color("SearchBarBackgroundColor") // #E9E1F3
	let manualReviewCommentLabelColor = Color("ManualReviewCommentLabelColor") // #444444
	let commentsTextFieldBorderColor = Color("CommentsTextFieldBorderColor") // #A0A0A0
	let commentsTextFieldBackground = Color("CommentsTextFieldBackground") // #FAFCFF
	let receiptStatusPending = Color("ReceiptStatusPending") // #DD7A01
	let receiptStatusManualReview = Color("ReceiptStatusManualReview") // #DD7901
	let receiptStatusRejected = Color("ReceiptStatusRejected") // #BA0517
    let lightSilverBackground = Color("LightSilverBackgroundColor") // #F4F6F9
    let productBackground = Color("ProductBackgroundColor") // #F1F3FB
    let paymentCardText = Color("PaymentCardTextColor") // #747B84
    let shippingBackground = Color("ShippingBackgroundColor") // #FAFBFC
	let vibrantViolet = Color("VibrantViolet") // #BA01FF
	let lightGray = Color("LightGray") // #E0E0E0
    let wheelIndicatorBackground = Color("DarkGreyColor") // #23475F
    let scratchCardBackground = Color("LightGreyColor") // #D9D9D9
    let scratchCardDotsBackground = Color("ScratchCardDotsColor") //#F8EFFF
    let scratchCardText = Color("ScratchCardTextColor") // #939393
    let noLuckViewLineColor = Color("NoLuckViewLineColor") // #FFCBC7
    let referralCardBackground = Color("ReferralCardBackgroundColor") // #5A1BA9
    let purchaseCompleted = Color("VoucherCodeBorderColor") // #2E844A
    let referralCodeColor = Color("ReferralCodeColor") // #6A6A6A
    let referralCodeCopy = Color("TextRedeemButtonColor") // #8C4B02
    let referralCodeBackground = Color("ReferralCodeBackgroundColor") // #F5EDE2
    let referralCodeBorder = Color("ReferralCodeBorderColor") // #DC9F4B
	let fortuneWheelStrokeColor = Color("FortuneWheelStrokeColor") // #23475F
	let fortuneWheelSecondaryStrokeColor = Color("FortuneWheelSecondaryStrokeColor") // #D9D9D9
}

struct TierColor {
    let silver = Color(hex: "#A0A0A0")
    let gold = Color(hex: "#FCC003")
    let bronze = Color(hex: "#CA9b8C")
    let platinum = Color(hex: "#E3E3E3")
    let ruby = Color(hex: "#E28787")
}
