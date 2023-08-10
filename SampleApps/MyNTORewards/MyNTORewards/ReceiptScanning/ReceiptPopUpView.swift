//
//  ReceiptPopUpView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptPopUpView: View {
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
	@Environment(\.dismiss) private var dismiss
	@State var showManualReviewRequest: Bool = false
	@State var selectedDetent: PresentationDetent = .height(800)
	
	@State var detents: Set<PresentationDetent> = [.height(800), .height(524)]
	var body: some View {
		VStack(spacing: 20) {
			HStack {
				Spacer()
				Button {
					dismiss()
				} label: {
					Image(systemName: "xmark")
						.foregroundColor(.gray)
				}
				.padding(.trailing, 10)
				.accessibility(identifier: AppAccessibilty.receipts.closeButton)
			}
			.padding(.top, 12)
			if showManualReviewRequest {
				ManualReviewInputView(showManualReviewRequest: $showManualReviewRequest, selectedDetent: $selectedDetent,
									  receiptNumber: "42588",
									  receiptDate: "13/07/2023",
									  amount: "INR 32392",
									  points: "432 Points")
			} else {
				ReceiptDetailView(receiptNumber: "42588",
								  receiptDate: "13/07/2023",
								  amount: "INR 32392",
								  points: "432 Points",
								  showManualReviewRequest: $showManualReviewRequest, selectedDetent: $selectedDetent)
			}
		}
		.presentationDetents(detents, selection: $selectedDetent)
		
		.onChange(of: selectedDetent) { newValue in
			if newValue == .height(800) {
				updateDetentsWithDelay()
			} else {
				detents = [.height(800), .height(524)]
//				updateDetentsWithDelay()
			}
		}
	}
	func updateDetentsWithDelay() {
		Task {
			//(1 second = 1_000_000_000 nanoseconds)
			try? await Task.sleep(nanoseconds: 100_000_000)
//			guard selectedDetent == .height(800) else { return }
//			detents = [.height(800)]
			detents = [selectedDetent]
		}
	}
}

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
				VStack(alignment: .leading) {
					Text("Receipt \(receiptNumber)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
					Spacer()
					Text("Date: \(receiptDate)")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("\(amount)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
					Spacer()
					Text("\(points) Points")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptPointsText)
				}
				.padding(.trailing, 15)
			}
			.padding(.horizontal)
			.padding(.bottom, 8)
		}
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
			.frame(height: 470)
		}
		.background(.white)
		.cornerRadius(4)
		.padding()
		Button {
			showManualReviewRequest = true
			selectedDetent = .height(524)
		} label: {
			Text("Request a Manual Review")
				.foregroundColor(.black)
		}
		.padding(.top, 10)
		Button {
			// Download
		} label: {
			Text("Download")
				.foregroundColor(.black)
		}
		.padding(.top, 12)
	}
}

struct ReceiptPopUpView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptPopUpView()
    }
}
