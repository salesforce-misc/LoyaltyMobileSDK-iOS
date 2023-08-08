//
//  ReceiptsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptsView: View {
	@State var searchText = ""
	@StateObject var viewModel = ReceiptListViewModel()
	@StateObject var routerpath = RouterPath()
	@StateObject var cameraModel = CameraModel()
    @State var showCapturedImage: Bool = false
    @State var capturedImage: UIImage?

	var body: some View {
		NavigationStack(path: $routerpath.path) {
			VStack(spacing: 12) {
				HStack(spacing: 8) {
					ReceiptSearchBar(fieldValue: $viewModel.searchText)
						.padding(.leading)
					Button {
						cameraModel.showCamera = true
//						routerpath.presentedFullSheet = .receiptCongrats(points: 50)
					} label: {
						Text("New")
							.font(.boldButtonText)
							.longFlexibleButtonStyle()
							.frame(width: 120)
					}
					.frame(width: 81, height: 48)
					.padding(.horizontal, 16)
					.accessibilityIdentifier(AppAccessibilty.receipts.newButton)
					
				}
				.padding(.top, 12)
				ReceiptList(receipts: viewModel.searchText.isEmpty ? viewModel.receipts : viewModel.filteredReceipts)
					.loytaltyNavigationTitle("Receipts")
					.loyaltyNavBarSearchButtonHidden(true)
			}
			.withAppRouter()
			.withSheetDestination(sheetDestination: $routerpath.presentedSheet)
			.withFullScreenCover(fullSheetDestination: $routerpath.presentedFullSheet)
			.environmentObject(routerpath)
			.environmentObject(cameraModel)
			.background(Color.theme.background)
		}
		.background(Color.theme.background)
		.fullScreenCover(isPresented: $cameraModel.showCamera) {
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
//			.accessibilityIdentifier("camera_view")
            
        }
        
	}
}

struct ReceiptsView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptsView()
    }
}
