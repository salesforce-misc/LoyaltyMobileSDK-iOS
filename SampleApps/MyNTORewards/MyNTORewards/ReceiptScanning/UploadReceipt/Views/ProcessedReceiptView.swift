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
	
	var body: some View {
        if let processedReceipt = viewModel.processedReceipt {
			ZStack {
				VStack {
					VStack(alignment: .leading, spacing: 20) {
						Text("Receipt \(processedReceipt.receiptNumber)")
							.font(.offerTitle)
							.accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberLabel)
						HStack {
							Text("Store: \(processedReceipt.storeName)")
								.accessibilityIdentifier(AppAccessibilty.Receipts.storeLabel)
							Spacer()
							Text("Date: \(processedReceipt.receiptDate)")
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptDate)
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
							ProcessedReceiptList(items: processedReceipt.lineItem)
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
					Text(StringConstants.Receipts.submitButton)
						.onTapGesture {
							Task {
								do {
									guard let receiptSFDCId = processedReceipt.receiptSFDCId else { return }
									isLoading = true
									let success = try await viewModel.submitForProcessing(receiptId: receiptSFDCId)
									if success {
										viewModel.receiptState = .submitted
										try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "", forced: true)
									}
									isLoading = false
								} catch {
									isLoading = false
								}
							}
						}
						.longFlexibleButtonStyle()
						.accessibilityIdentifier(AppAccessibilty.Receipts.submitReceiptButton)
					Button(StringConstants.Receipts.tryAgainButton) {
						// button action
						Task {
							routerPath.presentedSheet = nil
							do {
								try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "", forced: true)
							}
						}
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							cameraModel.showCamera = true
						}
					}
					.foregroundColor(.black)
					.accessibilityIdentifier(AppAccessibilty.Receipts.tryAgainButtonProcessedReceipt)
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
        } else {
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
}

struct ProcessedReceiptView_Previews: PreviewProvider {
	static var previews: some View {
		ProcessedReceiptView()
            .environmentObject(dev.processedReceiptVM)
            .environmentObject(dev.camVM)
            .environmentObject(dev.receiptVM)
	}
}
