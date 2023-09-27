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
	@StateObject var imageVM = ImageViewModel()
	@State private var tabIndex = 0
	@State private var showManualReviewRequest = false
	@State private var showPhotoDownloadedAlert = false
	@State private var isTableLoading = true
	var tabbarItems = ["Items Detected", "Receipt Image"]
	let receipt: Receipt
    var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("Receipt \(receipt.receiptId)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberText)
					Text("Date: \(receipt.purchaseDate ?? " - ")")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.Receipts.receiptDateText)
				}
				Spacer()
				VStack(alignment: .trailing, spacing: 8) {
					Text("\(receipt.totalAmount ?? "0")")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.Receipts.receiptAmountText)
					Text("\(receipt.totalPoints?.truncate(to: 2) ?? "0") Points")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.Receipts.receiptPointsText)
				}
				.padding(.trailing, 15)
			}
			.padding(.horizontal, 30)
			.padding(.top, 10)
			TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
			ZStack {
				Color.theme.background
				TabView(selection: $tabIndex) {
					if processedReceiptViewModel.processedAwsResponse != nil {
						ProcessedReceiptList(eligibleItems: processedReceiptViewModel.eligibleItems,
											 ineligibleItems: processedReceiptViewModel.inEligibleItems)
							.backgroundStyle(Color.theme.background)
							.padding(20)
							.tag(0)
					} else {
						if isTableLoading {
							ProgressView()
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color.theme.background)
						} else {
							Text("No Data")
						}
					}
						ZoomableScrollView {
							LoyaltyAsyncImage(url: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg") { image in
//							LoyaltyAsyncImage(url: receipt.imageUrl) { image in
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
					
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			}
			Button {
				showManualReviewRequest = true
			} label: {
				Text(isManualReview() ? "Submitted for Manual Review" : "Request a Manual Review")
					.foregroundColor(isManualReview() ? .gray : .black)
			}
			.disabled("Manual Review" == receipt.status)
			.padding(.top, 10)
			Button {
				Task {
					//TODO: Replace with url from response(receipt.imageURL).
					let urlString = "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg"
					await imageVM.getImage(url: urlString)
					if let image = imageVM.images[urlString.MD5] {
						UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
						showPhotoDownloadedAlert = true
					}
				}
			} label: {
				Text("Download Image")
					.foregroundColor(.black)
			}
			.padding(.vertical, 20)
		}
		.onAppear {
			Task {
				do {
					isTableLoading = true
					try await processedReceiptViewModel.getProcessedReceiptItems(from: receipt)
					isTableLoading = false
				} catch {
					isTableLoading = false
					// TODO: show error on processed receipts tab
				}
			}
		}
		.loytaltyNavigationTitle("Receipt Details")
		.loyaltyNavBarSearchButtonHidden(true)
		.sheet(isPresented: $showManualReviewRequest) {
			ManualReviewInputView(showManualReviewRequest: $showManualReviewRequest, receipt: receipt)
				.interactiveDismissDisabled()
				.presentationDetents(Set([ .height(524)]))
		}
		.alert(StringConstants.Receipts.receiptSavedToPhotos, isPresented: $showPhotoDownloadedAlert, actions: {
			Text("")
		})
		.environmentObject(processedReceiptViewModel)
    }
	
	private func isManualReview() -> Bool {
		"Manual Review" == receipt.status
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
										   totalPoints: 50,
										   createdDate: "03/05/2022",
										   imageUrl: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg",
										   processedAwsReceipt: "{\n  \"totalAmount\" : \"$154.06\",\n  \"storeName\" : \"East Repair Inc.\"n}"))
    }
}
