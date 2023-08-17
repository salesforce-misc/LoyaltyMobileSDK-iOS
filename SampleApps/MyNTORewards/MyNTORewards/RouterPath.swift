//
//  RouterPath.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

@MainActor
class RouterPath: ObservableObject {
	@Published var presentedSheet: SheetDestination?
	
	func dismissSheets() {
		presentedSheet = nil
	}
	
	func presentSheet(destination: SheetDestination) {
		dismissSheets()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.presentedSheet = destination
		}
	}
}
