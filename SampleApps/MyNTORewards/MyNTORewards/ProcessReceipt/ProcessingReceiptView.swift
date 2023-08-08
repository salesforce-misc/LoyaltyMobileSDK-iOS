//
//  ProcessingReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 03/08/23.
//

import SwiftUI

struct ProcessingReceiptView: View {
	@StateObject private var receiptViewModel = ReceiptViewModel()
	@EnvironmentObject var routerPath: RouterPath
    var body: some View {
		Group {
			switch receiptViewModel.receiptState {
			case .processing:
				ProcessingView()
			case .processed:
				ProcessedReceiptView()
			case .submitted:
				ReceiptCongratsView(points: 25)
			}
		}
		.environmentObject(receiptViewModel)
    }
}

struct ProcessingView: View {
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 40) {
				ProgressView()
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//							routerPath.presentedSheet = .processedReceipt
							receiptViewModel.receiptState = .processed
						}
					}
				VStack(spacing: 8) {
					Text("Scanning Receipt...")
						.font(.scanningReceiptTitleFont)
						.fontWeight(.heavy)
						.accessibilityIdentifier(AppAccessibilty.receipts.scanningReceiptLabel)
					Text("Hang in there! This may take a minute.")
						.font(.scanningReceiptCaptionFont)
						.accessibilityIdentifier(AppAccessibilty.receipts.scanningReceiptSubtitle)
				}
			}
			Spacer()
			Button {
				routerPath.presentedSheet = nil
				routerPath.presentedFullSheet = nil
				// Todo:- cancel the processing api call
			} label: {
				Text("Cancel")
					.foregroundColor(.black)
					.font(.scanningReceiptCancelFont)
			}
		}
	}
}

struct ProcessingReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingReceiptView()
    }
}
