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
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
	
	var body: some View {
        if let processedReceipt = viewModel.processedReceipt {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Receipt \(processedReceipt.receiptNumber)")
                        .font(.offerTitle)
                        .accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberLabel)
                    HStack {
                        Text("Store: \(processedReceipt.storeName)")
                            .accessibilityIdentifier(AppAccessibilty.receipts.storeLabel)
                        Spacer()
                        Text("Date: \(processedReceipt.receiptDate)")
                            .accessibilityIdentifier(AppAccessibilty.receipts.receiptDate)
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
                        receiptViewModel.receiptState = .submitted
                    }
                    .longFlexibleButtonStyle()
                    .accessibilityIdentifier(AppAccessibilty.receipts.submitReceiptButton)
                Button(StringConstants.Receipts.tryAgainButton) {
                    // button action
                    routerPath.presentedSheet = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        cameraModel.showCamera = true
                    }
                }
                .foregroundColor(.black)
                .accessibilityIdentifier(AppAccessibilty.receipts.tryAgainButtonProcessedReceipt)
            }
            .padding(.vertical, 20)
            .background(Color.theme.background)
        } else {
            VStack {
                Spacer()
                ProcessingErrorView()
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
                .accessibilityIdentifier(AppAccessibilty.receipts.backButton)
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
