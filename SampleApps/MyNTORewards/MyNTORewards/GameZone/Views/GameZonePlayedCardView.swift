//
//  GameZonePlayedCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 22/12/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct GameZonePlayedCardView: View {
    let gameCardModel: GameDefinition
    @State private var showNoLuckScreen = false
    @State private var showCongratsScreen = false
    @State private var popupDetent = PresentationDetent.fraction(0.80)
    
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
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(gameCardModel.name)
                        .font(.gameTitle)
                        .foregroundColor(Color.theme.lightText)
                        .accessibilityIdentifier("game_zone_expired_card_title")
                    Spacer()
                }
                Text(getGameTypeText())
                    .font(.redeemText)
                    .foregroundColor(Color.theme.superLightText)
                Text(getFormattedplayedLabel())
                    .font(.labelText)
                    .padding([.vertical], 2)
                    .padding([.horizontal], 12)
                    .background(Color.theme.expiredBackgroundText)
                    .foregroundColor(Color.theme.lightText)
                    .cornerRadius(4)
                Text(getRewardLabel())
                    .font(.redeemText)
                    .foregroundColor(Color.theme.superLightText)
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
        ).onTapGesture(perform: {
            if let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
               let rewardType = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId})?.rewardType {
                if rewardType == .noReward {
                    showNoLuckScreen = true
                    
                } else {
                    showCongratsScreen = true
                }
            } else {
                showNoLuckScreen = true
            }
        })
        .sheet(isPresented: $showNoLuckScreen) {
            PlayedGameNoLuckView()
                .presentationDetents(
                    [.fraction(0.80)],
                    selection: $popupDetent
                )
        }
        .sheet(isPresented: $showCongratsScreen) {
            if let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
               let reward = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId}) {
                PlayedGameCongratsView(offerText: reward.rewardValue ?? "",
                                         rewardType: reward.rewardType ?? .voucher)
                .presentationDetents(
                    [.fraction(0.80)],
                    selection: $popupDetent
                )
            }
        }
    }
    
    func getFormattedplayedLabel() -> String {
        guard let expirationDate = gameCardModel.participantGameRewards.first?.expirationDate else { return "Never Played" }
        return "\(StringConstants.Gamification.playedTab) \(expirationDate.toString(withFormat: "dd MMM yyyy"))"
    }
    
    func getRewardLabel() -> String {
        guard let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
              let reward = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId})
        else {return StringConstants.Gamification.noWonLabel}
        if reward.rewardType == .noReward {
            return StringConstants.Gamification.noWonLabel
        } else {
            return "\(StringConstants.Gamification.wonLabel):\(reward.name)"
        }
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

#Preview {
    GameZonePlayedCardView(gameCardModel: DeveloperPreview.instance.expiredGame)
}
