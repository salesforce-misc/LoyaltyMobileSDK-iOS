//
//  OrderDetailsViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/23.
//

import Foundation

final class OrderDetailsViewModel: ObservableObject {
	@Published var selectedIndex = 0
	@Published var isOrderPlacedNavigationActive = false
	
	func createOrder() {
		isOrderPlacedNavigationActive = true
	}
	
	func selectTabIndex(_ index: Int) {
		selectedIndex = index
	}
}
