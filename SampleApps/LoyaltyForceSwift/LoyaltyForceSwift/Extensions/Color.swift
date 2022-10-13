//
//  Color.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/30/22.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let backgroundPink = Color("BackgroundPinkColor")
    let darkBlue = Color("DarkBlueColor")
    let lightBlue = Color("LightBlueColor")
    let superLightBlue = Color("SuperLightBlueColor")
    let titleColor = Color("TitleColor")
    
    let listSeparatorPink = Color("ListSeparatorColor")
    let textInactive = Color("TextInactiveColor")
    let superLightText = Color("TextSuperLightColor")
    let lightButton = Color("ButtonLightColor")
    let darkButton = Color("ButtonDarkColor")
    let textFieldBackground = Color("TextFieldBackgroundColor")
    let textFieldBorder = Color("TextFieldBorderColor")
    let voucherCode = Color("VoucherCodeColor")
    let voucherBorder = Color("VoucherCodeBorderColor")
    let voucherBackground = Color("VoucherCodeBackgroundColor")
    let points = Color("PointsColor")
    let badgeBackground = Color("BadgeTextBackgroundColor")
    let memberStatus = Color("GoldColor")
    let progressBarBackground = Color("ProgressBarBackgroundColor")
    let tierPoints = Color("TierPointsColor")
    let lightBlackText = Color("TextLightBlackColor") // #231F20
}
