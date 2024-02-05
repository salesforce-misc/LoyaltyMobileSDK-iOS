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
		static let submitButton = "Submit"
		static let manualReviewTitle = "Manual review"
		static let cancelButton = "Cancel"
        static let backButton = "Back"
		static let commentsHeader = "Comments"
		static let enterCommentsPlaceholder = "Enter the reason for manual request...."
		static let tryAgainButton = "Try Again"
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
		static let submitForManualReviewButton = "Submit for Manual Review"
        static let noEligibleItemsText = "We couldn’t find any eligible items in the receipt."
	}
    
    struct Gamification {
        static let successGreetingTitle = "Congratulations!"
        static let successVoucherGreeting = "You've won a{n}for your next purchase. To redeem your reward, go to the Voucher section."
		static let playedGameSuccessGreeting = "Here’s your reward:{n}"
		static let playedGameSuccessGreetingForVoucher = "Here’s your reward:{n}\nTo redeem your reward, go to Vouchers."
        static let successPointsGreeting = "You've won{n}that you can redeem on your next purchase."
        static let successNoRewardGreeting = "Better luck next time!"
        static let successCustomRewardGreeting = "You’ve won a reward."

        static let placeHolderOfferText = "20% off"
        static let backButtonTitle = "Back"
        static let successBackButtonTitle = "Play More"
        static let failureMessageTitle = "Better luck next time!"
        static let failureBodyText = ""
        static let failureBodySubText = "Thank you for playing! Stay tuned for more offers."
        static let gameZoneHeader = "Game Zone"
        static let activeTab = "Active"
        static let expiredTab = "Expired"
        static let playedTab = "Played"
        static let expiringToday = "Expiring today"
        static let expiringTomorrow = "Expiring tomorrow"
        static let expiryLabel = "Expiry"
        static let expiredTabHeaderLabel = "No longer available"
        static let playedTabHeaderLabel = "Games Played in Last 90 Days"
        static let spinaWheelHeaderLabel = "Spin a wheel"
        static let spinaWheelSubHeaderLabel = "Spin the wheel and unlock instant rewards!"
        // swiftlint:disable line_length
        static let spinaWheelBodyLabel = "Grab this exclusive onetime offer and win some exciting rewards. For more information, refer to the terms and conditions."
        // swiftlint:enable line_length
        static let tapSpinaWheeltoPlayLabel = ""
		static let tapSpinButtonLabel: LocalizedStringKey = "**SPIN**"
        static let scratchCardTitleLabel = "Scratch a Card and Win"
        static let scratchCardSubTitleLabel = "Unlock instant rewards!"
        static let scratchCardLabel = " SCRATCH & WIN "
        static let scratchCardBodyLabel = "Grab this exclusive onetime offer and win some exciting rewards."
        static let wonLabel = "Won"
        static let noWonLabel = "Won"
        static let voucherSectionButton = "Go to the Voucher Section"

		// Empty State
		static let emptySubtitleForActiveView = "When you have games available, you’ll see them here."
		static let emptySubtitleForExpiredView = "When your games expire, you’ll see them here."
		static let emptySubtitleForPlayedView = "After you play a game, you’ll see it here."
    }
    
    struct Referrals {
        static let referralsTitle = "My Referrals"
        static let backButton = "Back"
        static let infoTitle = "YOUR REFERRALS in Last 90 Days"
        static let sent = "Invitations Sent"
        static let accepted = "Invitations Accepted"
        static let vouchersEarned = "Vouchers Earned"
        static let pointsEarned = "Points Earned"
        static let referButton = "Refer Now"
        static let signUpTitle = "Sign Up and Refer Your Friends"
        static let signUpText = "SShare your referral code with friends and get rewarded when they place their first order."
        static let signUpEmailText = "Email Address"
        static let signUpButton = "Sign Up"
        static let joinTitle = "Join Referral Program"
        static let joinText = "Join our referral program and share your referral code with friends to get rewarded."
        static let joinButton = "Join"
        static let referTitle = "Start Referring"
        static let referText = "Your referral code is ready! Share the referral code with your friends and get rewarded when they place their first order."
        static let referEmailText = "Enter the email addresses of your friends…"
        static let commaText = "Add a comma after each email address."
        static let shareText = "Share Invite"
        static let copyText = "Copy"
        static let copiedText = "Referral code copied"
        static let doneButton = "Done"
        static let successTab = "Completed"
        static let inProgressTab = "In Progress"
        static let sectionOneTitle = "Recent"
        static let sectionTwoTitle = "One Month Ago"
        static let sectionThreeTitle = "Three Months Ago"
        static let shareReferralText = "Use my referral link to sign up: "
        static let noReferralsFound = "After you refer a friend, you’ll see it here."
        static let emailSentAlertTitle = "Email Sent"
        static let emailSentAlertText = "An invitation email was sent to your friends with your referral link."
        static let emailUnableToSent = "Something doesn't look right with one of the email addresses."
        static let emailValidationError = "Something doesn't look right with one of the email addresses."
        static let enrollmentError = "We couldn’t enroll you as a member of the referral program. Try joining again."
        static let genericError = "Oops! Something went wrong while processing the request. Try again."
    }
}
