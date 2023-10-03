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
		static let uploadReceiptButton = "Upload"
		static let searchPlaceholder = "Search receipts..."
		static let submitForManualReviewButton = "Submit"
		static let manualReviewTitle = "Manual review"
		static let cancelButton = "Cancel"
        static let backButton = "Back"
		static let commentsHeader = "Comments"
		static let enterCommentsPlaceholder = "Enter comments..."
		static let tryAgainButton = "Try Again"
		static let submitButton = "Submit"
		static let receiptUploadedText = "Your receipt is uploaded!"
		static let uploadAnotherReceiptButton = "Upload Another Receipt"
		static let processingScreenTitle = "Generating preview..."
		static let processingScreenSubtitle = "Hang in there! This may take a minute."
        static let processingErrorMessage = "Oops! Something went wrong while processing the request. Try again."
		static let receiptSavedToPhotos = "Receipt saved to Photos"
        // swiftlint:disable:next line_length
        static let fileSizeErrorMessage = "Oops! The image size is over 5MB. Try uploading an image of smaller file size or try lowering your device camera resolution."
	}
}
