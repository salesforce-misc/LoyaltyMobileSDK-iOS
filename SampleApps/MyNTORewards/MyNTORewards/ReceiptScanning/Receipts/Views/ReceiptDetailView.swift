//
//  ReceiptDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 24/08/23.
//

import SwiftUI

struct ReceiptDetailView: View {
	@EnvironmentObject var routerPath: RouterPath
    @EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@State private var tabIndex = 0
	@State private var showManualReviewRequest = false
	var tabbarItems = ["Eligible Items", "Receipt Image"]
	let receipt: Receipt
    var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("Receipt \(receipt.receiptId)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
					Text("Date: \(receipt.purchaseDate.toDateString() ?? " - ")")
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
//							LoyaltyAsyncImage(url: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg") { image in
							LoyaltyAsyncImage(url: receipt.imageUrl) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fit)
							} placeholder: {
								ProgressView()
									.frame(maxWidth: .infinity, maxHeight: .infinity)
							}
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
				Text("Request a Manual Review")
					.foregroundColor(.black)
			}
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
		.loytaltyNavigationTitle("Outdoor Collection")
		.loyaltyNavBarSearchButtonHidden(true)
		.sheet(isPresented: $showManualReviewRequest) {
			ReceiptPopUpView(showManualReviewRequest: $showManualReviewRequest)
				.interactiveDismissDisabled()
				.presentationDetents(Set([ .height(524)]))
		}
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptDetailView(receipt: Receipt(id: "Receipt 56g",
										   receiptId: "3453463",
										   name: "Receipt",
										   status: "Draft",
										   storeName: "Ratna cafe",
										   purchaseDate: "08/09/2023",
										   totalAmount: "$4500",
										   totalPoints: "50",
										   createdDate: "03/05/2022",
										   imageUrl: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg",
										   processedAwsReceipt: "{\n  \"totalAmount\" : \"$154.06\",\n  \"storeName\" : \"East Repair Inc.\"n}"))
    }
}
