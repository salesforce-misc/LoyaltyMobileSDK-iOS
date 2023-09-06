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
	let receiptNumber: String
	let receiptDate: String
	let amount: String?
	let points: String?
	var tabbarItems = ["Eligible Items", "Receipt Image"]
    var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("Receipt \(receiptNumber)")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
                    Text("Date: \(receiptDate.toDateString() ?? " - ")")
						.font(.transactionDate)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
				}
				Spacer()
				VStack(alignment: .trailing, spacing: 8) {
					Text("\(amount ?? "0")")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
					Text("\(points ?? "0") Points")
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
					ProcessedReceiptListWithHeader(processedListItems: processedReceiptViewModel.processedReceipt?.lineItem ?? [])
						.backgroundStyle(Color.theme.background)
						.padding(20)
						.tag(0)
					ZoomableScrollView {
						Image("scanned_receipt")
							.resizable()
					}
					.padding(20)
					.tag(1)
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
		ReceiptDetailView(receiptNumber: "2323",
                          receiptDate: "08/27/2023",
                          amount: "5660",
                          points: "418")
    }
}
