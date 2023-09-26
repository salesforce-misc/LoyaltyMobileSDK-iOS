//
//  CapturedImageView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/20/23.
//

import SwiftUI
import Photos
import LoyaltyMobileSDK

struct CapturedImageView: View {
    @EnvironmentObject var rootVM: AppRootViewModel
    @EnvironmentObject var viewModel: ProcessedReceiptViewModel
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
    @Binding var showCapturedImage: Bool
    @Binding var capturedImage: UIImage?
	@EnvironmentObject var routerPath: RouterPath
	@Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
            
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.75)
                    .padding(.bottom, 50)
            }
            
            VStack {
                
                HStack {
                    Button(action: {
                        withAnimation {
                            showCapturedImage = false
                            capturedImage = nil
                        }
                        
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 25))
                            .padding(10)
                            .foregroundColor(.white)
                    }
					.accessibilityIdentifier(AppAccessibilty.Receipts.backButtonCapturedImageView)
                    .buttonStyle(CircularButtonStyle())
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()

                Button("Upload") {
                    // Handle processing image
                    if let image = capturedImage {
                        
                        viewModel.clearProcessedReceipt()
                        Task {
                            do {
                                try await viewModel.processImage(membershipNumber: rootVM.member?.membershipNumber ?? "", image: image)
                            } catch {
                                Logger.error("Failed to process the image")
                            }
                            
                        }
                       
                        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        withAnimation {
                            showCapturedImage = false
                            capturedImage = nil
							dismiss()
							viewModel.receiptState = .processing
							routerPath.presentedSheet = .processingReceipt(receiptListViewModel: receiptListViewModel)
                        }
                    }
                    
                }
				.accessibilityIdentifier(AppAccessibilty.Receipts.processButton)
                .buttonStyle(LightLongButton())
                
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .onTapGesture {
                        withAnimation {
                            showCapturedImage = false
                            capturedImage = nil
                        }
                    }
            }
        }
        
    }
}
