//
//  ProcessedReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ProcessedReceiptView: View {
	@StateObject var viewModel = ProcessedReceiptViewModel()
	@EnvironmentObject var cameraModel: CameraModel
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
	var receiptNumber = "2323"
	var storeName = "Dmart"
	var receiptDate = "17/07/2023"
	
	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 20) {
				Text("Receipt \(receiptNumber)")
					.font(.offerTitle)
					.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberLabel)
				HStack {
					Text("Store: \(storeName)")
						.accessibilityIdentifier(AppAccessibilty.receipts.storeLabel)
					Spacer()
					Text("Date: \(receiptDate)")
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptDate)
				}
				.font(.offerText)
			}
			.padding(.horizontal)
			VStack(spacing: 0) {
				Rectangle()
					.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
					.frame(height: 1)
					.padding()
					
				ReceiptTableTitleRow()
					.font(.receiptItemsTitleFont)
				Rectangle()
					.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
					.frame(height: 1)
					.padding()
				ScrollView {
					ProcessedReceiptList(items: viewModel.processedListItems)
					Rectangle()
						.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
						.frame(height: 1)
						.padding()
				}
				.frame(height: 400)
			}
			.background(.white)
			.cornerRadius(4)
			.padding()
			Spacer()
			Text("Submit")
				.onTapGesture {
//					routerPath.presentFullSheet(destination: .receiptCongrats(points: 45))
					receiptViewModel.receiptState = .submitted
				}
				.longFlexibleButtonStyle()
				.accessibilityIdentifier(AppAccessibilty.receipts.submitReceiptButton)
			Button("Try Again") {
				// button action
				routerPath.presentedSheet = nil
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					cameraModel.showCamera = true
				}
			}
			.foregroundColor(.black)
			.accessibilityIdentifier(AppAccessibilty.receipts.tryAgainButtonProcessedReceipt)
		}
		.padding(.top, 20)
		.background(Color.theme.background)
	}
}

struct ProcessedReceiptView_Previews: PreviewProvider {
	static var previews: some View {
		ProcessedReceiptView()
	}
}
