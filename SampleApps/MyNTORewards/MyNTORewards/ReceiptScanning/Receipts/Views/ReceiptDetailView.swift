//
//  ReceiptDetailView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/08/23.
//

import SwiftUI

struct ReceiptDetailView: View {
	@StateObject var viewModel = ProcessedReceiptViewModel()
	let receiptNumber: String
	let receiptDate: String
	let amount: String
	let points: String
	@Binding var showManualReviewRequest: Bool
	@Binding var selectedDetent: PresentationDetent
	var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("Receipt \(receiptNumber)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
					Text("Date: \(receiptDate)")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
				}
				Spacer()
				VStack(alignment: .trailing, spacing: 8) {
					Text("\(amount)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
					Text("\(points) Points")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptPointsText)
				}
				.padding(.trailing, 15)
			}
			.padding(.horizontal)
			.padding(.bottom, 8)
			
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
					//ProcessedReceiptList(items: viewModel.processedListItems)
					Rectangle()
						.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
						.frame(height: 1)
						.padding()
				}
				.frame(maxHeight: .infinity)
			}
			.background(.white)
			.cornerRadius(4)
			.padding()
			Spacer()
			Button {
				showManualReviewRequest = true
				selectedDetent = .manualReview
			} label: {
				Text("Request a Manual Review")
					.foregroundColor(.black)
			}
			.padding(.top, 10)
			Button {
				//TODO: Download
			} label: {
				Text("Download")
					.foregroundColor(.black)
			}
			.padding(.vertical, 20)
		}
	}
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptDetailView(receiptNumber: "42588",
						  receiptDate: "13/07/2023",
						  amount: "INR 32392",
						  points: "432 Points",
						  showManualReviewRequest: .constant(true),
						  selectedDetent: .constant(.large)
		)
    }
}
