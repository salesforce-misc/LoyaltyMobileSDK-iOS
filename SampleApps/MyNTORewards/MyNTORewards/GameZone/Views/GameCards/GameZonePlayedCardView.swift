//
//  GameZonePlayedCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 22/12/23.
//

import SwiftUI
import GamificationMobileSDK

struct GameZonePlayedCardView: View, GameCardView {
    @EnvironmentObject var routerPath: RouterPath
    let gameCardModel: GameDefinition
    @State private var showNoRewardsScreen = false
    @State private var showRewardsInfoScreen = false
    
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
                        .accessibilityIdentifier("game_zone_played_card_title")
                    Spacer()
                }
                Text(getGameTypeText())
                    .font(.redeemText)
                    .foregroundColor(Color.theme.superLightText)
                Text(getFormattedPlayedLabel())
                    .font(.labelText)
                    .padding([.vertical], 2)
                    .padding([.horizontal], 12)
                    .background(Color.theme.expiredBackgroundText)
                    .foregroundColor(Color.theme.lightText)
                    .cornerRadius(4)
				if let rewardLabel = getRewardLabel() {
					Text(rewardLabel)
						.font(.redeemText)
						.foregroundColor(Color.theme.superLightText)
				}
            }
            .padding(.vertical, 8)
			.padding(.leading, 10)
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
            handleNavigation()
        })
        .sheet(isPresented: $showNoRewardsScreen) {
            PlayedGameNoLuckView().presentationDetents([.fraction(0.80)])
        }
        .sheet(isPresented: $showRewardsInfoScreen) {
            if let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
               let reward = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId}) {
                PlayedGameCongratsView(onVoucherTapAction: handleVoucherNavigation, offerText: reward.name,
                                       rewardType: reward.rewardType ?? .voucher).presentationDetents([.fraction(0.80)])
            }
        }
    }
    
    func handleVoucherNavigation() {
        self.routerPath.navigateFromGameZone(to: .vouchers)
    }
    
    func handleNavigation() {
        if let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
           let rewardType = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId})?.rewardType {
            if rewardType == .noReward {
                showNoRewardsScreen = true
            } else {
                showRewardsInfoScreen = true
            }
        } else {
            showNoRewardsScreen = true
        }
    }
    
    func getFormattedPlayedLabel() -> String {
        // TODO: Update the below code to used played date when it is available in the getGames API.
		/*
        guard let expirationDate = gameCardModel.participantGameRewards.first?.expirationDate else { return "Never Played" }
        return "\(StringConstants.Gamification.playedTab) \(expirationDate.toString(withFormat: "dd MMM yyyy"))"
		*/
		return "\(StringConstants.Gamification.playedTab)"
    }
    
    func getRewardLabel() -> String? {
        guard let rewardId = gameCardModel.participantGameRewards.first?.gameRewardId,
              let reward = gameCardModel.gameRewards.first(where: {$0.gameRewardId == rewardId})
        else { return nil }
        return reward.name
    }
}

#Preview {
    GameZonePlayedCardView(gameCardModel: DeveloperPreview.instance.expiredGame)
}
