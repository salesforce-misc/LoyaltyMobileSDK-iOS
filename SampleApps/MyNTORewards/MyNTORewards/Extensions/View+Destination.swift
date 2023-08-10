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
			case .congrats:
				Text("Congrats")
			default:
				Text("All other views")
			}
		}
	}
	
	func withSheetDestination(sheetDestination: Binding<SheetDestination?>) -> some View {
		
		sheet(item: sheetDestination) { sheet in
			switch sheet {
			case .storedReceipt:
				ReceiptPopUpView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.theme.background)
					.interactiveDismissDisabled()
					.presentationDragIndicator(.hidden)
			case .processingReceipt:
				ProcessingReceiptView()
					.interactiveDismissDisabled()
			case .processedReceipt:
				ProcessedReceiptView()
					.interactiveDismissDisabled()
			}
		}
	}
	
	func withFullScreenCover(fullSheetDestination: Binding<FullSheetDestination?>) -> some View {
		fullScreenCover(item: fullSheetDestination) { fullSheet in
			switch fullSheet {
			case .receiptCongrats(let points):
				ReceiptCongratsView(points: points)
			case .test:
				Text("Test")
			}
		}
	}
}
