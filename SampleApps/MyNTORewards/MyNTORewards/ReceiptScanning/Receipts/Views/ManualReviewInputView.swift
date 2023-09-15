//
//  ManualReviewInputView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI

struct ManualReviewInputView: View {
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
	@EnvironmentObject var rootVM: AppRootViewModel
	@Binding var showManualReviewRequest: Bool
	@Environment(\.dismiss) var dismiss
	@State private var comment: String = ""
	@State private var isLoading = false
	let receipt: Receipt
	
    var body: some View {
		ZStack {
			VStack {
				HStack {
					Spacer()
					Button {
						showManualReviewRequest = false
					} label: {
						Image(systemName: "xmark")
							.foregroundColor(.gray)
					}
					.padding(.trailing, 10)
					.accessibility(identifier: AppAccessibilty.Receipts.closeButton)
				}
				.padding(.top, 12)
				VStack(spacing: 20) {
					HStack {
						Text(StringConstants.Receipts.manualReviewTitle)
							.font(.manualReviewTitleLabel)
							.padding(.leading, 25)
							.padding(.top, 2)
						Spacer()
					}
					HStack {
						VStack(alignment: .leading, spacing: 8) {
							Text("Receipt \(receipt.receiptId)")
								.font(.transactionText)
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberText)
							Text("Date \(receipt.purchaseDate.toDateString() ?? "-")")
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
					.padding(.horizontal, 25)
					.padding(.bottom, 8)
				}
				CommentsInputView(comment: $comment)
					.padding(8)
				Text(StringConstants.Receipts.submitForManualReviewButton)
					.onTapGesture {
						Task {
							do {
								isLoading = true
								let success = try await processedReceiptViewModel.submitForManualReview(receiptId: receipt.id, comments: comment)
								if success {
									dismiss()
									try await receiptListViewModel.getReceipts(membershipNumber: rootVM.member?.membershipNumber ?? "", forced: true)
								}
								isLoading = false
							} catch {
								isLoading = false
								// MARK: handle error
							}
						}
					}
					.longFlexibleButtonStyle(disabled: comment.isEmpty)
				Button {
					dismiss()
				} label: {
					Text(StringConstants.Receipts.cancelButton)
						.foregroundColor(.black)
				}
				.padding(.bottom, 20)
				.accessibilityIdentifier(AppAccessibilty.Receipts.backButton)
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.theme.background)
			
			if isLoading {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.theme.progressBarBackground)
					.opacity(0.7)
			}
		}
    }
}

struct CommentsInputView: View {
	@Binding var comment: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			Text(StringConstants.Receipts.commentsHeader)
				.padding(.leading)
				.font(.manualReviewCommentLabel)
				.foregroundColor(Color.theme.manualReviewCommentLabelColor)
			TextField(StringConstants.Receipts.enterCommentsPlaceholder, text: $comment, axis: .vertical)
				.lineLimit(8, reservesSpace: true)
				.textFieldStyle(GrayedTextFieldStyle())
		}
	}
}

struct ManualReviewInputView_Previews: PreviewProvider {
    static var previews: some View {
		ManualReviewInputView(showManualReviewRequest: .constant(true), receipt: Receipt(id: "Receipt 56g",
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
