//
//  GameZoneExpiredCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneExpiredCardView: View {
    let gameCardModel: GameDefinition
    
    var body: some View {
        VStack {
            ZStack {
                if gameCardModel.type == .scratchCard {
                    Color.theme.expiredBackgroundText
                }
                Image(getImageName())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .saturation(0)
            }
            .frame(width: 165, height: 90)
            .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(gameCardModel.name)
                        .font(.gameTitle)
                        .foregroundColor(Color.theme.lightText)
                        .accessibilityIdentifier("game_zone_expired_card_title")
                    Spacer()
                }
                Spacer()
                Text(getGameTypeText())
                    .font(.redeemText)
                    .foregroundColor(Color.theme.superLightText)
                Text(getFormattedExpiredLabel())
                    .font(.labelText)
                    .padding([.vertical], 2)
                    .padding([.horizontal], 12)
                    .background(Color.theme.expiredBackgroundText)
                    .foregroundColor(Color.theme.lightText)
                    .cornerRadius(4)
            }
            .padding(.all, 6)
            Spacer()
        }
        .frame(width: 165, height: 203)
        .background(Color.white)
        .cornerRadius(10)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(
                    color: Color.gray.opacity(0.4),
                    radius: 10,
                    x: 0,
                    y: 0
                )
        )
    }
    
    @ViewBuilder func navigationAction() -> some View {
        switch gameCardModel.type {
        case .spinaWheel:
            FortuneWheelView()
        case .scratchCard:
            ScratchCardView()
        }
    }
    
    func getFormattedExpiredLabel() -> String {
        "Expired"
    }
    
    func getGameTypeText() -> String {
        var gameType: String
        switch gameCardModel.type {
        case .spinaWheel:
            gameType = "Spin a Wheel"
        case .scratchCard:
            gameType = "Scratch Card"
        }
        return gameType
    }
    
    func getImageName() -> String {
        var name: String
        switch gameCardModel.type {
        case .spinaWheel:
            name = "img-fortune-wheel"
        case .scratchCard:
            name = "img-scratch-card"
        }
        return name
    }
}

//struct GameZoneExpiredCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameZoneExpiredCardView(gameCardModel: dev.expiredGame)
//    }
//}
