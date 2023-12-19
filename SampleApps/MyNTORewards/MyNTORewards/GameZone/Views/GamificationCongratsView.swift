//
//  GamificationCongratsView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 10/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GamificationCongratsView: View {
    @Environment(\.dismiss) var dismiss
    var offerText: String = "20% off"
    var rewardType: RewardType = .voucher
    let imageSize = CGSize(width: 168, height: 167)
    
    var body: some View {
        VStack {
            // Scrollview  is for Dynamic font support
            ScrollView {
                VStack {
                    Image("img-congrats")
                        .resizable()
                        .scaledToFit()
                    Image("img-gifts-color-art")
                        .frame(width: imageSize.width, height: imageSize.height)
                        .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                        .padding(.bottom, 29)
                        .padding(.top, -imageSize.height/2)
                    VStack(spacing: 5) {
                        Text(StringConstants.Gamification.successGreetingTitle)
                            .font(.congratsTitle)
                            .foregroundColor(Color.theme.lightText)
                        Text(getAttributedStringForGreetingsBody())
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }.diableBounceForScrollView()
            .overlay {
               ConfettiView()
            }
            Button(StringConstants.Gamification.successBackButtonTitle) {
                dismiss()
            }
            .buttonStyle(DarkFlexibleButton(buttonFont: .boldButtonText))
            .padding(.bottom, 50)
        }.edgesIgnoringSafeArea(.top)
    }
    
    func getRewrdsMessage() -> String {
        var message = ""
        switch rewardType {
        case .voucher:
            message = StringConstants.Gamification.successVoucherGreeting
        case .loyaltyPoints:
            message = StringConstants.Gamification.successPointsGreeting
        case .raffle:
            message = ""
        case .noReward:
            message = StringConstants.Gamification.successNoRewardGreeting
        case .customReward:
            message = StringConstants.Gamification.successCustomRewardGreeting
        }
        return message
    }
	
	private func getOfferTextWithSpacing(for offerText: String) -> String {
		offerText.isEmpty ? " " : " \(offerText) "
	}
	
    func getAttributedStringForGreetingsBody() -> AttributedString {
        let greetingsText = getRewrdsMessage()
        let replacedString = greetingsText.replacingOccurrences(of: "{n}", with: getOfferTextWithSpacing(for: offerText))
        var attributedString = AttributedString(replacedString)
        attributedString.foregroundColor = Color.theme.superLightText
        attributedString.font = .congratsText
        if let range = attributedString.range(of: offerText) {
            attributedString[range].foregroundColor = Color.theme.lightText
            attributedString[range].font = .offerTitle
        }
        return attributedString
    }
}

#Preview {
	GamificationCongratsView()
}
