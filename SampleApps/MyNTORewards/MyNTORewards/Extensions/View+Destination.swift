//
//  File.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 02/08/23.
//

import SwiftUI

@MainActor
extension View {
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
			}
		}
	}
}
