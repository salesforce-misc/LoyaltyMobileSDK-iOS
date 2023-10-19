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
    
}
