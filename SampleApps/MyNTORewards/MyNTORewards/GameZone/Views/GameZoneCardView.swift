//
//  GameZoneCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 17/10/23.
//

import SwiftUI
import GamificationMobileSDK

struct GameZoneCardView: View {
	@State var shouldShowGameScreen = false
	let gameCardModel: GameDefinition
	let isDateInToday: (Date) -> Bool
	let isDateInTomorrow: (Date) -> Bool
	
	init(
		gameCardModel: GameDefinition,
		isDateInToday: @escaping (Date) -> Bool = Calendar.current.isDateInToday,
		isDateInTomorrow: @escaping (Date) -> Bool = Calendar.current.isDateInTomorrow
	) {
		self.gameCardModel = gameCardModel
#if DEBUG
		if UITestingHelper.isUITesting {
			self.isDateInToday = { _ in UITestingHelper.isExpiringToday }
			self.isDateInTomorrow = { _ in UITestingHelper.isExpiringTomorrow }
		} else {
			self.isDateInToday = isDateInToday
			self.isDateInTomorrow = isDateInTomorrow
		}
#else
		self.isDateInToday = isDateInToday
		self.isDateInTomorrow = isDateInTomorrow
#endif
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			gameThumbnail
			VStack(alignment: .leading, spacing: 8) {
				gameName
				Text(getGameTypeText())
					.font(.redeemText)
					.foregroundColor(Color.theme.superLightText)
				expiryLabel
			}
			.padding(10)
		}
		.contentShape(Rectangle()) // To enable tapping on entire VStack instead of just the contents inside it.
		.accessibilityIdentifier(gameCardModel.type == .scratchCard ? "scratch_card_item" : "spin_a_wheel_item")
		.frame(minWidth: 165)
		.frame(height: 203)
		.background(Color.white)
		.cornerRadius(10)
		.background(cardBackground)
		.navigationDestination(isPresented: $shouldShowGameScreen) { gameDestination }
		.onTapGesture { showGameScreen() }
	}
	
	@ViewBuilder
	var gameDestination: some View {
		switch gameCardModel.type {
		case .spinaWheel:
			FortuneWheelView(gameDefinitionModel: gameCardModel, backToRoot: {
				dismissGameScreen()
			}).toolbar(.hidden, for: .tabBar, .navigationBar)
		case .scratchCard:
			ScratchCardView(gameDefinitionModel: gameCardModel, backToRoot: {
				dismissGameScreen()
			}).toolbar(.hidden, for: .tabBar, .navigationBar)
		}
	}
	
	var gameThumbnail: some View {
		ZStack {
			if gameCardModel.type == .scratchCard {
				Color.theme.expiredBackgroundText
			}
			Image(getImageName())
				.resizable()
				.aspectRatio(contentMode: .fill)
		}
		.frame(minWidth: 165)
		.frame(height: 90)
		.cornerRadius(5, corners: [.topLeft, .topRight])
	}
	
	var gameName: some View {
		VStack {
			Text(gameCardModel.name)
				.font(.gameTitle)
				.lineLimit(2)
				.multilineTextAlignment(.leading)
				.foregroundColor(Color.theme.lightText)
				.accessibilityIdentifier("game_zone_active_card_title")
			Spacer()
		}
		.frame(height: 44)
	}
	
	var expiryLabel: some View {
		Text(getFormattedExpiredLabel())
			.font(.labelText)
			.padding([.vertical], 3)
			.padding([.horizontal], 12)
			.background(.black)
			.foregroundColor(.white)
			.cornerRadius(4)
	}
	
	var cardBackground: some View {
		Rectangle()
			.fill(Color.white)
			.cornerRadius(10)
			.shadow(
				color: Color.gray.opacity(0.4),
				radius: 10,
				x: 0,
				y: 0
			)
	}
	
	private func showGameScreen() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
			shouldShowGameScreen = true
		}
	}
	
	private func dismissGameScreen() {
		shouldShowGameScreen = false
	}
	
	private func getFormattedExpiredLabel() -> String {
		guard let expirationDate = gameCardModel.participantGameRewards.first?.expirationDate else { return "Never Expires" }
		if isDateInToday(expirationDate) {
			return StringConstants.Gamification.expiringToday
		}
		if isDateInTomorrow(expirationDate) {
			return StringConstants.Gamification.expiringTomorrow
		}
		return "\(StringConstants.Gamification.expiryLabel) \(expirationDate.toString(withFormat: "dd MMM yyyy"))"
	}
	
	private func getGameTypeText() -> String {
		var gameType: String
		switch gameCardModel.type {
		case .spinaWheel:
			gameType = "Spin a Wheel"
		case .scratchCard:
			gameType = "Scratch Card"
		}
		return gameType
	}
	
	private func getImageName() -> String {
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
	GameZoneCardView(gameCardModel: DeveloperPreview.instance.activeGame)
}
