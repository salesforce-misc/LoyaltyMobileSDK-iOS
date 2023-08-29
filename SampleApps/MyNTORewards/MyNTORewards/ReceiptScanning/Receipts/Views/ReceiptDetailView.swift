//
//  ReceiptDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 24/08/23.
//

import SwiftUI

struct ReceiptDetailView: View {
	@EnvironmentObject var routerPath: RouterPath
	@State private var tabIndex = 0
	@State private var showManualReviewRequest = false
	@State var lastScaleValue: CGFloat = 1.0
	@State var scale: CGFloat = 1.0
	@StateObject var processedReceiptViewModel = ProcessedReceiptViewModel()
	let receiptNumber: String
	let receiptDate: String
	let amount: Double
	let points: Double
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
					Text("\(amount, specifier: "%.0f")")
						.font(.transactionText)
						.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
					Text("\(points, specifier: "%.0f") Points")
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
					ProcessedReceiptListWithHeader(processedListItems: processedReceiptViewModel.processedListItems)
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
				routerPath.presentedSheet = .storedReceipt
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
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptDetailView(receiptNumber: "2323", receiptDate: "08/27/2023", amount: 5660, points: 418)
    }
}
