//
//  StringConstants.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/08/23.
//

import Foundation
import SwiftUI

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
		static let uploadingReceiptTitle = "Uploading receipt..."
		static let processingReceiptTitle = "Processing receipt..."
		static let unableToProcessSomeItems = "We couldn’t process some items in the receipt."
		static let unableToProcessReceipt = "We couldn’t process the receipt."
		static let processingScreenSubtitle = "Hang in there! This may take a minute."
        static let processingErrorMessage = "Something went wrong. Try again."
		static let receiptSavedToPhotos = "Receipt saved to Photos"
        static let fileSizeErrorMessage = "Image size exceeds 5 MB. Either resize the image or recapture with a lower resolution."
        static let formatUnsupported = "File type is not supported. Files can only be in HEIC, JPEG and PNG format."
		static let emptyReceiptsViewTitle = "Looks like you haven’t uploaded any receipts yet"
		static let emptyReceiptsViewBody = "Upload your receipts and get loyalty points for the eligible items."
        static let requestForManualReviewButton = "Request a Manual Review"
        static let noEligibleItemsText = "We couldn’t find any eligible items in the receipt."
	}
    
    struct Gamification {
        static let successGreetingTitle = "Congratulations!!!"
        static let successGreetingBody = "You have won \n A voucher of 20% off for your next purchase. \nGo to the voucher section to claim your reward!"
        static let placeHolderOfferText = "20% off"
        static let backButtonTitle = "Back"
        static let failureMessageTitle = "Better luck next time!"
        static let failureBodyText = "Thank you for playing..."
        static let failureBodySubText = "Keep a watch out for more such offers."
        static let gameZoneHeader = "Game Zone"
        static let activeTab = "Active"
        static let expiredTab = "Expired"
        static let expiringToday = "Expiring today"
        static let expiringTomorrow = "Expiring tomorrow"
        static let expiryLabel = "Expiry"
        static let expiredTabHeaderLabel = "Expired in the last 90 Days"
        static let spinaWheelHeaderLabel = "Spin a wheel!"
        static let spinaWheelSubHeaderLabel = "Get a chance to win instant rewards!"
        // swiftlint:disable line_length
        static let spinaWheelBodyLabel = "This is a one time offer exclusively for you. This offer if declined may not be repeated. Please refer to the terms and conditions for more information."
        // swiftlint:enable line_length
        static let tapSpinaWheeltoPlayLabel = "Tap ‘Spin’ to play."
		static let tapSpinButtonLabel: LocalizedStringKey = "Tap to **SPIN**"
    }
}
