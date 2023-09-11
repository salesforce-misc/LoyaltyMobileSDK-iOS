//
//  ReceiptDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 24/08/23.
//

import SwiftUI

struct ReceiptDetailView: View {
	@EnvironmentObject var routerPath: RouterPath
    @StateObject var processedReceiptViewModel = ProcessedReceiptViewModel()
	@State private var tabIndex = 0
	@State private var showManualReviewRequest = false
	var tabbarItems = ["Eligible Items", "Receipt Image"]
	let receipt: Receipt
    var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("Receipt \(receipt.receiptId ?? "-")")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
					Text("Date: \(receipt.purchaseDate?.toDateString() ?? " - ")")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
				}
				Spacer()
				VStack(alignment: .trailing, spacing: 8) {
					Text("\(receipt.totalAmount ?? "0")")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
					Text("\(receipt.totalPoints ?? "0") Points")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptPointsText)
				}
				.padding(.trailing, 15)
			}
			.padding(.horizontal, 30)
			.padding(.top, 10)
			TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
			ZStack {
				Color.theme.background
				TabView(selection: $tabIndex) {
					if let processedAwsResponse = processedReceiptViewModel.processedAwsResponse {
						ProcessedReceiptListWithHeader(processedAwsResponse: processedAwsResponse)
							.backgroundStyle(Color.theme.background)
							.padding(20)
							.tag(0)
						ZoomableScrollView {
							Image("scanned_receipt")
								.resizable()
						}
						.padding(20)
						.tag(1)
					} else {
						// TODO: Handle data unavailable case
						Text("No Data")
					}
					
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			}
			Button {
				showManualReviewRequest = true
			} label: {
				Text("Manual Review" == receipt.status ? "Submitted for Manual Review" : "Request a Manual Review")
					.foregroundColor(.black)
			}
			.disabled("Manual Review" == receipt.status)
			.padding(.top, 10)
			Button {
				//TODO: Download
			} label: {
				Text("Download Image")
					.foregroundColor(.black)
			}
			.padding(.vertical, 20)
		}
		.onAppear {
			do {
				try processedReceiptViewModel.getProcessedReceiptItems(from: receipt)
			} catch {
				// TODO: show error on processed receipts tab
			}
		}
		.loytaltyNavigationTitle("Receipt Details")
		.loyaltyNavBarSearchButtonHidden(true)
		.sheet(isPresented: $showManualReviewRequest) {
			ManualReviewInputView(showManualReviewRequest: $showManualReviewRequest, receipt: receipt)
				.interactiveDismissDisabled()
				.presentationDetents(Set([ .height(524)]))
		}
		.environmentObject(processedReceiptViewModel)
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptDetailView(receipt: Receipt())
    }
}
