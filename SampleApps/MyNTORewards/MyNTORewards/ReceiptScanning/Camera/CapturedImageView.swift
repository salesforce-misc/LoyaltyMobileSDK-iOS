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
    @Binding var capturedImageData: Data?

    var body: some View {
        ZStack {
            Color.black
            
            if let imageData = capturedImageData {
                if let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.75)
                        .padding(.bottom, 50)
                        .onAppear {
                            if imageData.count > 5 * 1024 * 1024 {
                                showCapturedImage = false
                                cameraViewModel.showErrorView = ErrorViewData(showError: true, 
                                                                              errorType: .sizeTooBig,
                                                                              errorMessage: StringConstants.Receipts.fileSizeErrorMessage)
                                cameraViewModel.showCamera = false
                                dismiss()
                                return
                            }
                        }
                }
            }
            
            VStack {
                
                HStack {
                    Button(action: {
                        withAnimation {
                            showCapturedImage = false
                            capturedImageData = nil
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
                    if let imageData = capturedImageData {
                        
                        processedReceiptViewModel.clearProcessedReceipt()
                        Task {
                            do {
                                try await processedReceiptViewModel.uploadImage(membershipNumber: rootVM.member?.membershipNumber ?? "", imageData: imageData)
                            } catch {
                                Logger.error("Failed to process the image")
                            }
                        }
                        
                        withAnimation {
                            showCapturedImage = false
                            capturedImageData = nil
							dismiss()
							processedReceiptViewModel.receiptState = .processing
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                            capturedImageData = nil
                        }
                    }
            }
        }
        
    }
}
