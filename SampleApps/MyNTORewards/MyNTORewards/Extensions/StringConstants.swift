//
//  StringConstants.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/08/23.
//

import Foundation

struct StringConstants {
	struct Receipts {
		static let receiptsListTitle = "Receipts"
		static let uploadReceiptButton = "New"
		static let searchPlaceholder = "Search receipts..."
		static let submitForManualReviewButton = "Submit"
		static let manualReviewTitle = "Manual review"
		static let cancelButton = "Cancel"
        static let backButton = "Back"
		static let commentsHeader = "Comments"
		static let enterCommentsPlaceholder = "Enter the reason for manual request...."
		static let tryAgainButton = "Try Again"
		static let submitButton = "Submit"
		static let receiptUploadedText = "Your receipt is uploaded!"
		static let uploadAnotherReceiptButton = "Upload Another Receipt"
		static let processingScreenTitle = "Generating preview..."
		static let processingScreenSubtitle = "Hang in there! This may take a minute."
        static let processingErrorMessage = "Something went wrong. Try again."
		static let receiptSavedToPhotos = "Receipt saved to Photos"
        static let fileSizeErrorMessage = "Image size exceeds 5 MB. Either resize the image or recapture with a lower resolution."
        static let formatUnsupported = "File type is not supported. Files can only be in HEIC, JPEG and PNG format."
		static let emptyReceiptsViewTitle = "Looks like you haven’t uploaded any receipts yet"
		static let emptyReceiptsViewBody = "Upload your receipts and get loyalty points for the eligible items."
        static let requestForManualReviewButton = "Request a Manual Review"
        static let noEligibleItemsText = "No Eligible Items found in the Receipt!"
	}
    
    struct Gamification {
        static let successGreetingTitle = "Congratulations!!!"
        static let successGreetingBody = "You have won \n A voucher for 20% off for your nextpurchase. Go to the voucher section to claim your reward!"
        static let placeHolderOfferText = "20% off"
        static let backButtonTitle = "Back"
        static let failureMessageTitle = "Better luck next time!"
        static let failureBodyText = "Thank you for playing..."
        static let failureBodySubText = "Keep a watch out for more such offers."
    }
}
