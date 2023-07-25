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
    @State private var showCamera = false
    @State var showCapturedImage: Bool = false
    @State var capturedImage: UIImage?

	var body: some View {
		VStack(spacing: 12) {
			HStack(spacing: 8) {
				ReceiptSearchBar(fieldValue: $viewModel.searchText)
					.padding(.leading)
				Button {
                    self.showCamera = true
				} label: {
					Text("New")
						.font(.boldButtonText)
						.longFlexibleButtonStyle()
						.frame(width: 120)
				}
				.frame(width: 81, height: 48)
				.padding(.horizontal, 16)
				
			}
			.padding(.top, 12)
			ReceiptList(receipts: viewModel.searchText.isEmpty ? viewModel.receipts : viewModel.filteredReceipts)
			.loytaltyNavigationTitle("Receipts")
			.loyaltyNavBarSearchButtonHidden(true)
		}
		.background(Color.theme.background)
        .fullScreenCover(isPresented: $showCamera) {
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
            }
            
        }
        
	}
}

struct ReceiptsView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptsView()
    }
}
