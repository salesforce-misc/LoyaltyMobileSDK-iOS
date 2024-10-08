//
//  PlayedGameCongratsView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 22/12/23.
//

import SwiftUI
import GamificationMobileSDK

struct PlayedGameCongratsView: View {
    let onVoucherTapAction: () -> Void
    @Environment(\.dismiss) var dismiss
    let imageSize = CGSize(width: 165, height: 165)
    var offerText: String = "20% off"
    var rewardType: RewardType = .voucher
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 12)
            // Scrollview  is for Dynamic font support
            ScrollView {
                VStack {
                    ZStack(alignment: .center) {
                        Image("img-game-gift")
                            .frame(width: imageSize.width, height: imageSize.height)
                            .aspectRatio(imageSize.width/imageSize.height, contentMode: .fit)
                    }.padding(.top, 20)
                    VStack(spacing: 10) {
                        Text(StringConstants.Gamification.successGreetingTitle)
                            .font(.congratsTitle)
                            .foregroundColor(Color.theme.lightText)
                        Text(getAttributedStringForGreetingsBody())
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 16)
                    .padding(.top, 40)
                    Spacer()
                }
            }.diableBounceForScrollView()
            VStack(spacing: 20) {
                Button(StringConstants.Gamification.backButtonTitle) {
                    dismiss()
                }
                .buttonStyle(DarkFlexibleButton(buttonFont: .boldButtonText))
                if rewardType == .voucher {
                    Button {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onVoucherTapAction()
                        }
                    } label: {
                        Text(StringConstants.Gamification.voucherSectionButton)
                            .foregroundColor(Color.theme.lightText)
                            .font(.scanningReceiptCancelFont)
                    }
                }

            }.padding([.bottom], 40)
        }
    }
    
    private func getOfferTextWithSpacing(for offerText: String) -> String {
        offerText.isEmpty ? " " : " \(offerText) "
    }
    
    func getAttributedStringForGreetingsBody() -> AttributedString {
		let greetingsText: String
		if rewardType == .voucher {
			greetingsText = StringConstants.Gamification.playedGameSuccessGreetingForVoucher
		} else {
			greetingsText = StringConstants.Gamification.playedGameSuccessGreeting
		}
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
    PlayedGameCongratsView(onVoucherTapAction: {})
}
