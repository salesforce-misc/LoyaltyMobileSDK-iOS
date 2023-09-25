//
//  ProcessedReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ProcessedReceiptView: View {
    @EnvironmentObject var viewModel: ProcessedReceiptViewModel
	@EnvironmentObject var cameraModel: CameraViewModel
	@EnvironmentObject var receiptlistViewModel: ReceiptListViewModel
	@EnvironmentObject var rootViewModel: AppRootViewModel
	@EnvironmentObject var routerPath: RouterPath
	@State private var isLoading = false
	@State private var isError = false
	
	var body: some View {
		if let processedReceipt = viewModel.processedReceipt, !isError {
			ZStack {
				VStack {
					header(receipt: processedReceipt)
					ProcessedReceiptList(eligibleItems: viewModel.eligibleItems,
										 ineligibleItems: viewModel.inEligibleItems)
					.padding()
					Spacer()
					submitButton(receipt: processedReceipt)
					tryAgainButton(receipt: processedReceipt)
				}
				.padding(.vertical, 20)
				.background(Color.theme.background)
				if isLoading {
					ProgressView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(Color.theme.progressBarBackground)
						.opacity(0.7)
				}
			}
        } else { errorView }
	}
	
	private func header(receipt: ProcessedReceipt) -> some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Receipt \(receipt.receiptNumber)")
				.font(.offerTitle)
				.accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberLabel)
			HStack {
				Text("Store: \(receipt.storeName)")
					.accessibilityIdentifier(AppAccessibilty.Receipts.storeLabel)
				Spacer()
				Text("Date: \(receipt.receiptDate)")
					.accessibilityIdentifier(AppAccessibilty.Receipts.receiptDate)
			}
			.font(.offerText)
		}
		.padding(.horizontal)
	}
	
	private func submitButton(receipt: ProcessedReceipt) -> some View {
		Text(StringConstants.Receipts.submitButton)
			.onTapGesture {
				Task {
					do {
						isLoading = true
						let success = try await viewModel.updateStatus(receiptId: receipt.receiptSFDCId, status: .inProgress)
						if success {
							let receipt = await viewModel.wait(until: .processed,
												 forReceiptId: receipt.receiptSFDCId ?? "",
												 membershipNumber: rootViewModel.member?.membershipNumber ?? "",
												 delay: 2,
												 retryCount: 5)
							viewModel.receiptState = .submitted(receipt?.totalPoints)
							try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "",
																	   forced: true)
						} else { isError = true }
						isLoading = false
					} catch {
						isLoading = false
						isError = true
					}
				}
			}
			.longFlexibleButtonStyle()
			.accessibilityIdentifier(AppAccessibilty.Receipts.submitReceiptButton)
	}
	
	private func tryAgainButton(receipt: ProcessedReceipt) -> some View {
		Button(StringConstants.Receipts.tryAgainButton) {
			Task {
				routerPath.presentedSheet = nil
				do {
					isLoading = true
					let success = try await viewModel.updateStatus(receiptId: receipt.receiptSFDCId, status: .cancelled)
					if success {
						try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "",
																   forced: true)
					}
					isLoading = false
				} catch {
					isLoading = false
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				cameraModel.showCamera = true
			}
		}
		.foregroundColor(.black)
		.accessibilityIdentifier(AppAccessibilty.Receipts.tryAgainButtonProcessedReceipt)
	}
	
	private var errorView: some View {
		VStack {
			Spacer()
			ProcessingErrorView(message1: StringConstants.Receipts.processingErrorMessageLine1,
								message2: StringConstants.Receipts.processingErrorMessageLine2)
			Spacer()
			Spacer()
			Text(StringConstants.Receipts.tryAgainButton)
				.onTapGesture {
					// button action
					routerPath.presentedSheet = nil
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						cameraModel.showCamera = true
					}
				}
				.longFlexibleButtonStyle()
			Button {
				routerPath.presentedSheet = nil
			} label: {
				Text(StringConstants.Receipts.backButton)
					.foregroundColor(.black)
			}
			.padding(.bottom, 20)
			.accessibilityIdentifier(AppAccessibilty.Receipts.backButton)
		}
	}
}

struct ProcessedReceiptView_Previews: PreviewProvider {
	static var previews: some View {
		ProcessedReceiptView()
            .environmentObject(dev.processedReceiptVM)
            .environmentObject(dev.camVM)
            .environmentObject(dev.receiptVM)
	}
}
