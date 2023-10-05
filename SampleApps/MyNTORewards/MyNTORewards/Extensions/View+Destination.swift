//
//  File.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

@MainActor
extension View {
	func withAppRouter() -> some View {
		navigationDestination(for: RouterDestination.self) { destination in
			switch destination {
			case .receipts:
				ReceiptsView()
			}
		}
	}
	
	func withSheetDestination(sheetDestination: Binding<SheetDestination?>) -> some View {
		sheet(item: sheetDestination) { sheet in
			switch sheet {
			case .processingReceipt(let receiptListViewModel):
				ProcessingReceiptView()
					.environmentObject(receiptListViewModel)
					.interactiveDismissDisabled()
			}
		}
	}
}

// MARK: For processed receipt table field alignment
extension View {
	func productNameFrame() -> some View {
		self.frame(width: 100, alignment: .leading)
	}
	
	func quantityFrame() -> some View {
		self.frame(width: 55, alignment: .trailing)
	}
	
	func priceFrame() -> some View {
		self.frame(width: 60, alignment: .trailing)
	}
	
	func totalPriceFrame() -> some View {
		self.frame(width: 60, alignment: .trailing)
	}
	
	func productQuantitySpaceFrame() -> some View {
		self.frame(width: 2)
	}
}
