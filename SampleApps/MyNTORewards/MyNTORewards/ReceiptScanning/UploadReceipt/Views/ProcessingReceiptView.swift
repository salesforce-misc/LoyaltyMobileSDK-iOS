//
//  ProcessingReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 03/08/23.
//

import SwiftUI

struct ProcessingReceiptView: View {
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@EnvironmentObject var routerPath: RouterPath
    var body: some View {
		Group {
			switch processedReceiptViewModel.receiptState {
			case .processing:
				ProcessingView()
			case .processed:
				ProcessedReceiptView()
			case .submitted:
				ReceiptCongratsView(points: 25)
			}
		}
		.environmentObject(processedReceiptViewModel)
    }
}

struct ProcessingView: View {
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	
	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 40) {
				ProgressView()
				VStack(spacing: 8) {
					Text(StringConstants.Receipts.processingScreenTitle)
						.font(.scanningReceiptTitleFont)
						.fontWeight(.heavy)
						.accessibilityIdentifier(AppAccessibilty.receipts.scanningReceiptLabel)
					Text(StringConstants.Receipts.processingScreenSubtitle)
						.font(.scanningReceiptCaptionFont)
						.accessibilityIdentifier(AppAccessibilty.receipts.scanningReceiptSubtitle)
				}
			}
			Spacer()
			Button {
				routerPath.dismissSheets()
				// Todo:- cancel the processing api call
			} label: {
				Text(StringConstants.Receipts.cancelButton)
					.foregroundColor(.black)
					.font(.scanningReceiptCancelFont)
			}
			.padding(.bottom, 20)
		}
	}
}

struct ProcessingReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingReceiptView()
    }
}
