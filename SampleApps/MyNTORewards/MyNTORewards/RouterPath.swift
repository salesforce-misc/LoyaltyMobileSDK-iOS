//
//  RouterPath.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

@MainActor
class RouterPath: ObservableObject {
    @Published var path: [RouterDestination] = []
	@Published var pathFromHome: [RouterDestination] = []
	@Published var pathFromMore: [RouterDestination] = []
	@Published var presentedSheet: SheetDestination?
	
	func dismissSheets() {
		presentedSheet = nil
	}
    
    func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
	
	func navigateFromHome(to destination: RouterDestination) {
		pathFromHome.append(destination)
	}
	
	func navigateFromMore(to destination: RouterDestination) {
		pathFromMore.append(destination)
	}
	
	func presentSheet(destination: SheetDestination) {
		dismissSheets()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.presentedSheet = destination
		}
	}
}
