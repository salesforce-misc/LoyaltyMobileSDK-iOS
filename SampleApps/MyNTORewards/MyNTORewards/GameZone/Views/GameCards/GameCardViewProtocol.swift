//
//  GameCardViewProtocol.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 05/01/24.
//
import Foundation
import GamificationMobileSDK

protocol GameCardView {
	var gameCardModel: GameDefinition { get }
	func getGameTypeText() -> String
	func getImageName() -> String
}

extension GameCardView {
	func getGameTypeText() -> String {
		var gameType: String
		switch gameCardModel.type {
		case .spinaWheel:
			gameType = "Spin the Wheel"
		case .scratchCard:
			gameType = "Scratchcard"
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
