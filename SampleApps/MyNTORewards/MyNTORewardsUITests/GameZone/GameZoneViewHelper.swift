//
//  GameZoneViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Damodaram Nandi on 19/10/23.
//

import XCTest

final class GameZoneViewHelper: XCTestCase {
    
    static func goToGameZoneView(app: XCUIApplication) {
        app.tabBars.buttons["More"].tap()
        app.buttons["Game Zone"].tap()
    }
    
    static func goToScarthCardView(app: XCUIApplication) {
        goToGameZoneView(app: app)
        _ = app.cells.element.waitForExistence(timeout: 5)
       let element = app.images["img-scratch-card"]
        element.tap()
    }
    
    static func goToSpinaWheelView(app: XCUIApplication) {
        goToGameZoneView(app: app)
        _ = app.cells.element.waitForExistence(timeout: 5)
        let gameZoneCard = app.images["img-fortune-wheel"].firstMatch
       gameZoneCard.tap()
    }
    
}
