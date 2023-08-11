//
//  ReceiptsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptsView: View {
	@StateObject var viewModel = ReceiptListViewModel()
	@StateObject var routerpath = RouterPath()
	@StateObject var cameraViewModel = CameraViewModel()
	@StateObject var receiptViewModel = ReceiptViewModel()
	@State var searchText = ""
    @State var showCapturedImage: Bool = false
    @State var capturedImage: UIImage?

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				HStack(spacing: 0) {
					ReceiptSearchBar(fieldValue: $viewModel.searchText)
						.padding(.leading)
					Text(StringConstants.Receipts.uploadReceiptButton)
						.font(.boldButtonText)
						.longFlexibleButtonStyle()
						.frame(width: 180)
						.accessibilityIdentifier(AppAccessibilty.receipts.newButton)
						.onTapGesture {
							cameraViewModel.showCamera = true
						}
				}
				ReceiptList(receipts: viewModel.searchText.isEmpty ? viewModel.receipts : viewModel.filteredReceipts)
					.loytaltyNavigationTitle(StringConstants.Receipts.receiptsListTitle)
					.loyaltyNavBarSearchButtonHidden(true)
			}
			.withSheetDestination(sheetDestination: $routerpath.presentedSheet)
			.environmentObject(routerpath)
			.environmentObject(cameraViewModel)
			.environmentObject(receiptViewModel)
			.background(Color.theme.background)
		}
		.background(Color.theme.background)
		.fullScreenCover(isPresented: $cameraViewModel.showCamera) {
            ZStack {
                ZStack {
                    CameraView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
                        .zIndex(showCapturedImage ? 0 : 1)

                    if showCapturedImage {
                        CapturedImageView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
                            .transition(.move(edge: .trailing))
                            .zIndex(showCapturedImage ? 1 : 0)
                    }
                }
                .animation(.default, value: showCapturedImage)
				.environmentObject(routerpath)
            }
        }
	}
}

struct ReceiptsView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptsView()
    }
}
