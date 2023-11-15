//
//  GameZoneCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZoneCardView: View {
    let gameCardModel: GameDefinition
    @State var showGameScreen = false
    
    var body: some View {
        VStack {
            ZStack {
                if gameCardModel.type == .scratchCard {
                    Color.theme.expiredBackgroundText
                }
                Image(getImageName())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 165, height: 90)
            .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(gameCardModel.name)
                        .font(.gameTitle)
                        .foregroundColor(Color.theme.lightText)
                        .accessibilityIdentifier("game_zone_active_card_title")
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
                    .background(.black)
                    .foregroundColor(.white)
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
        .onTapGesture {
            showGameScreen.toggle()
        }
        .fullScreenCover(isPresented: $showGameScreen) {
            navigationAction()
        }
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
        guard let expiredDate = gameCardModel.endDate else { return "" }
        if Calendar.current.isDateInToday(expiredDate) {
            return "Expiring today"
        }
        if Calendar.current.isDateInTomorrow(expiredDate) {
            return "Expiring today"
        }
        return "Expiry \(expiredDate.toString(withFormat: "dd MMM yyyy"))"
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

struct GameZoneCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameZoneCardView(gameCardModel: dev.activeGame)
    }
}
