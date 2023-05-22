//
//  ProductViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 20/05/23.
//

import Foundation

class ProductViewModel: ObservableObject {
	@Published var quantitySelected = 1
	var basePrice = 209
	
	func getTotalAmount() -> Int {
		quantitySelected * basePrice
	}
}
