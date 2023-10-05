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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var rootVM: AppRootViewModel
    @EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
    @EnvironmentObject var routerPath: RouterPath
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @Binding var showCapturedImage: Bool
    @Binding var capturedImage: UIImage?
	@Binding var phAsset: PHAsset?

    var body: some View {
        ZStack {
            Color.black
            
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.75)
                    .padding(.bottom, 50)
                    .onAppear(perform: {
                        // Check the size immediately after image appears
//                        guard let imageData = image.pngData(), imageData.count <= 5 * 1024 * 1024 else {
//
//                            showCapturedImage = false
//                            cameraViewModel.showErrorView = true
//                            dismiss()
//                            return
//                        }
						guard let size = phAsset?.assetSize, size <= 5 else {
							showCapturedImage = false
							cameraViewModel.showErrorView = true
							dismiss()
							return
						}
                    })
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
                    if let image = phAsset {
                        
                        processedReceiptViewModel.clearProcessedReceipt()
                        Task {
                            do {
                                try await processedReceiptViewModel.processAsset(membershipNumber: rootVM.member?.membershipNumber ?? "", image: image)
                            } catch {
                                Logger.error("Failed to process the image")
                            }
                        }
                        
                        withAnimation {
                            showCapturedImage = false
                            capturedImage = nil
							dismiss()
							processedReceiptViewModel.receiptState = .processing
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
								routerPath.presentSheet(destination: .processingReceipt(receiptListViewModel: receiptListViewModel))
							}
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
