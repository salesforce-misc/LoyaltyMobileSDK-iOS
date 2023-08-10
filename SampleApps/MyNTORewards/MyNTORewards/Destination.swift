//
//  RouterDestination.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

enum RouterDestination: Identifiable, Hashable {
	static func == (lhs: RouterDestination, rhs: RouterDestination) -> Bool {
		lhs.id == rhs.id
	}
	
	var id: UUID {
		UUID()
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	case receipts
	case capturedReceipt
	case congrats
}

enum SheetDestination: Identifiable {
	var id: UUID {
		UUID()
	}
	
	case processedReceipt
	case storedReceipt
	case processingReceipt
}

enum FullSheetDestination: Identifiable {
	var id: UUID {
		UUID()
	}
	case receiptCongrats(points: Double)
	case test
}
