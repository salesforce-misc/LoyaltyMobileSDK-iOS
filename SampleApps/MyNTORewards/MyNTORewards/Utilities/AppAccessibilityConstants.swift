//
//  AppAccessibilityConstants.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 10/04/23.
//

enum AppAccessibilty {
    
    enum NavigationView {
        static let home = "home_barbutton"
        static let profile = "profile_barbutton"
        static let promotion = "promotion_barbutton"
        static let more = "more_barbutton"
    }
    
    enum Onboarding {
        static let onboardingView = "onboarding_View"
        static let joinButton = "join_button"
        static let alreadyMemberLabel = "already_member_label"
        static let loginButton = "login_button"
        static let image = "onboarding_image"
        static let pageDescription = "onboarding_description"
    }
    
    enum Signup {
        static let joinLabel = "Join"
        static let dismiss = "Join_dismiss"
        static let firstName = "first_name_textfield"
        static let lastName = "last_name_textfield"
        static let email = "email_textfield"
        static let phone = "phone_textfield"
        static let password = "password_textfield"
        static let confirmPassword = "confirm_textfield"
        static let agreeCheckbox = "agree_checkbox"
        static let agreeLabel = "agree_label"
        static let agreeButton = "agree_button"
        static let mailListCheckbox = "maillist_checkbox"
        static let mailListLabel = "maillist_label"
        static let joinButton = "join_button"
        static let alreadyMemberLabel = "already_member_label"
        static let loginButton = "signup_login_button"
    }
    
    enum SignIn {
        static let loginHeader = "login_header"
        static let userName = "username_textfield"
        static let password = "password_textfield"
        static let forgotPassword = "forgot_password"
        static let loginButton = "signIn_login_button"
        static let notAMember = "not_a_member_text"
        static let joinNow = "join_now_button"
    }
    
    enum More {
        static let profileImage = "profile_image"
        static let account = "account_label"
        static let address = "address_label"
        static let paymentMethod = "paymentMethod_label"
        static let orders = "orders_label"
		static let receipts = "receipts_label"
        static let support = "support_label"
        static let favourites = "favourites_label"
        static let logout = "logout_button"
        static let game = "game_label"
    }
    
    enum Promotion {
        static let header = "promotion_header"
        static let searchImage = "search_image"
        static let viewAll = "view_all"
        static let image = "image"
        static let name = "name"
        static let description = "description"
        static let endDate = "end_date"
        static let shopButton = "shop_button"
        static let joinButton = "join_button"
        static let dismissButton = "dismiss_button"
        static let leaveButton = "leave_button"
    }
    
    enum Home {
        static let userName = "username_label"
        static let rewardPoints = "reward_points_label"
        static let homePromotion = "home_promotion"
        
    }
    
    enum Voucher {
        static let header = "voucher_header"
        static let viewAll = "view_all_button"
        static let image = "image"
        static let name = "name"
        static let discount = "discount"
        static let status = "status"
        static let description = "description"
        static let dismissButton = "dismiss_button"
        static let closeButton = "close_button"
        static let qrCode = "qr_code"
        static let endDate = "end_date"
        static let voucherCode = "voucher_code"
    }
    
    enum Profile {
        static let image = "profile_image"
        static let userName = "user_name_label"
        static let userId = "userid_label"
        static let tierName = "tier_name_label"
        static let rewardPoints = "reward_points"
        static let rewardPointsText = "reward_points_label"
        static let qrCode = "qrcode"
        static let header = "profile_header"
    }
    
    enum QRCode {
        static let title =  "qr_title"
        static let closeImage = "close_image"
        static let profileImage = "profile_image"
        static let userName = "user_name"
        static let membershipNumber = "membership_number"
        static let qrImage = "qr_image"
        static let qrCodeText = "qr_code_label"
        static let closeButton = "close_button"
        static let qrDescription = "qr_description"
    }
    
    enum Transaction {
        static let logo = "logo"
        static let name = "name"
        static let date = "date"
        static let points = "points"
    }
    
    enum Benefits {
        static let name = "name"
        static let logo = "logo"
        static let description = "description"
    }
	
	enum Receipts {
		static let searchBar = "receipts_search_bar"
		static let newButton = "new_button"
		static let receiptsViewTitle = "receipts_title"
		static let chooseFromPhotos = "choose_from_photos"
		static let closeCameraButton = "close_camera_button"
		static let cameraShutterButton = "camera_shutter_button"
		static let processButton = "process_button"
		static let backButtonCapturedImageView = "back_button_captured_image_view"
		static let scanningReceiptLabel = "scanning_receipt"
		static let scanningProgressView = "scanning_receipt_progress_view"
		static let scanningReceiptSubtitle = "scanning_receipt_subtitle"
		static let submitReceiptButton = "submit_receipt"
		static let receiptNumberLabel = "receipt_number_label"
		static let storeLabel = "store_label"
		static let receiptDate = "receipt_date"
		static let tryAgainButtonProcessedReceipt = "try_again_processed_receipt"
		static let receiptSubmittedCongrats = "receipt_submitted_congrats"
		static let scanAnotherReceipt = "scan_another_receipt"
		static let receiptNumberText = "receipt_number_text"
		static let receiptDateText = "receipt_date_text"
		static let receiptAmountText = "receipt_amount_text"
		static let receiptPointsText = "receipt_points_text"
        static let receiptManualReviewText = "receipt_manual_review_text"
		static let closeButton = "close_button"
		static let submitForManualReviewButton = "submit_for_manual_review_button"
		static let backButton = "back_button_in_manual_review"
		static let receiptsIcon = "receipts_icon"
        static let errorBackButton = "back_button_in_error_view"
		static let noEligibleItemsFound = "no_eligible_items_found"
		static let eligibleItemsTitle = "eligible_items_title"
		static let ineligibleItemsTitle = "ineligible_items_title"
	}
    
    enum GameZone {
        static let header = "game_zone_header"
    }
}
