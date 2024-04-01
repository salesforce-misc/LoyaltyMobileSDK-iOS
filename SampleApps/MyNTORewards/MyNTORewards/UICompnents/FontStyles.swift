//
//  FontStyles.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/7/22.
//

import Foundation
import SwiftUI

extension Font {
    
    /// Shared
	static var previewMessageText: Font {
		return Font.custom("SFPro-Display", size: 14)
	}
    
    /// Already a member? Not a member?
    static var footerText: Font {
        return Font.custom("SFPro-Regular", size: 16)
    }
    
    /// button texts or modal title texts
    static var buttonText: Font {
        return Font.custom("SFPro-Semibold", size: 16)
    }
    
    static var boldButtonText: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var smallButtonText: Font {
        return Font.custom("SFPro-bold", size: 13.39)
    }
    
    /// Input fields placeholder text
    static var placeholderText: Font {
        return Font.custom("SFPro-Regular", size: 14)
    }
    
    /// Onbording
    static var onboardingText: Font {
        return Font.custom("SFPro-Semibold", size: 36)
    }
    
    /// Join
    static var aggreementText: Font {
        return Font.custom("Archivo-Regular", size: 14)
    }
    
    static var congratsTitle: Font {
        return Font.custom("SFPro-Bold", size: 24)
    }
    
    static var congratsText: Font {
        return Font.custom("SFProDisplay-Regular", size: 16)
    }
    
    /// Check you email
    
    static var skipText: Font {
        return Font.custom("SFPro-Medium", size: 16)
    }
    
    /// Create New Password
    
    static var textFieldLabel: Font {
        return Font.custom("Archivo-Semibold", size: 14)
    }
    
    /// Landing Page
    
    static var pageTitle: Font {
        return Font.custom("SFPro-Semibold", size: 24)
    }
    
    static var boldedText: Font {
        return Font.custom("SFPro-Semibold", size: 16)
    }
    
    static var regularText: Font {
        return Font.custom("SFPro-Regular", size: 14)
    }
    
    // Offer Card
    static var offerTitle: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var offerViewAll: Font {
        return Font.custom("SFPro-Bold", size: 13)
    }
    
    static var offerText: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
    
    static var labelText: Font {
        return Font.custom("SFPro-Medium", size: 11)
    }
    
    // Offers tabs
    static var offersTabSelected: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var offersTabUnselected: Font {
        return Font.custom("SFPro-Medium", size: 16)
    }
    
    // Transaction
    static var transactionText: Font {
        return Font.custom("SFPro-Bold", size: 13)
    }
    
    static var transactionDate: Font {
        return Font.custom("SFPro-Regular", size: 13)
    }
    
    static var transactionPoints: Font {
        return Font.custom("SFPro-Bold", size: 14)
    }
    
    static var transactionPeriod: Font {
        return Font.custom("Roboto-Regular", size: 14)
    }
    
    // Voucher Detail
    static var voucherTitle: Font {
        return Font.custom("SFPro-Bold", size: 24)
    }
    
    static var voucherText: Font {
        return Font.custom("SFPro-Regular", size: 14)
    }
    
    static var voucherButtonText: Font {
        return Font.custom("SFPro-Bold", size: 14)
    }
    
    /// Redeem Card
    static var redeemTitle: Font {
        return Font.custom("SFPro-Medium", size: 14)
    }
    
    static var redeemText: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
    
    static var pointsText: Font {
        return Font.custom("SFPro-Bold", size: 18)
    }
    
    /// My Profile
    static var profileTitle: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var profileSubtitle: Font {
        return Font.custom("SFPro-Bold", size: 14)
    }
    
    static var profileText: Font {
        return Font.custom("SFPro-Bold", size: 13)
    }
    
    static var editText: Font {
        return Font.custom("SFPro-Semibold", size: 13)
    }
    
    static var cardPointsText: Font {
        return Font.custom("SFPro-Bold", size: 32)
    }
    
    static var cardExpiringPointsText: Font {
        return Font.custom("SFPro-Bold", size: 12)
    }
    
    static var tierPointsText: Font {
        return Font.custom("SFPro-Bold", size: 13.58)
    }
    
    static var tierPointsNotes: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
    
    // QRCode View
    static var qrcodeTitle: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var qrcodeSubtitle: Font {
        return Font.custom("SFPro-Regular", size: 14)
    }
    
    static var qrcodeNumber: Font {
        return Font.custom("SFPro-Medium", size: 16)
    }
    
    /// Benefits
    static var benefitText: Font {
        return Font.custom("SFPro-Semibold", size: 14)
    }
    
    static var benefitDescription: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
    
    /// More
    
    static var nameText: Font {
        return Font.custom("Archivo-Bold", size: 18)
    }
    
    static var menuText: Font {
        return Font.custom("SFPro-Regular", size: 16)
    }
    
    /// Bottom Navbar
    static var tabTitle: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
    
    // empty state view
    static var emptyStateTitle: Font {
        return Font.custom("SFPro-Bold", size: 16)
    }
    
    static var emptyStateSubTitle: Font {
        return Font.custom("SFPro-Regular", size: 12)
    }
	
	static var smallHeaderText: Font {
		return Font.custom("Archivo-Bold", size: 14)
	}
	
	static var mediumHeaderText: Font {
		return Font.custom("Archivo-Bold", size: 15)
	}
	
	static var lightBodyText: Font {
		return Font.custom("Archivo", size: 15)
	}
	
	static var smallSubtitleText: Font {
		return Font.custom("Archivo-Medium", size: 12)
	}
	
	static var selectionTitleText: Font {
		return Font.custom("Archivo-SemiBold", size: 13)
	}
	
	static var productDetailSubtitleText: Font {
		return Font.custom("Roboto-Regular", size: 16)
	}
	
	static var loyaltyNavBarSubtitleText: Font {
		return Font.custom("Roboto-Regular", size: 16)
	}
	
	static var productDetailTitleText: Font {
		return Font.custom("Archivo-Bold", size: 22)
	}
	
	static var orderDetailTitleText: Font {
		return Font.custom("Archivo-Bold", size: 24)
	}
	
	static var productQuantityText: Font {
		return Font.custom("Archivo-Medium", size: 16)
	}
	
	static var totalAmountText: Font {
		return Font.custom("Archivo-Bold", size: 20)
	}
	
	static var productShippingText: Font {
		return Font.custom("Archivo", size: 10)
	}
    
    /// checkout confirm order
    
    static var dropDownText: Font {
        return Font.custom("Archivo-Regular", size: 12)
    }
    
    static var voucherHederText: Font {
        return Font.custom("Archivo-Medium", size: 13)
    }
    
    static var useMyPointsText: Font {
        return Font.custom("Archivo-Semibold", size: 13)
    }
    
    static var amountText: Font {
        return Font.custom("Archivo-ExtraBold", size: 20)
    }
	
	/// Receipt items
	
	static var receiptItemsFont: Font {
		return Font.custom("IBMPlexMono-Regular", size: 10)
	}
	
	static var receiptItemsTitleFont: Font {
		return Font.custom("IBMPlexMono-SemiBold", size: 10)
	}
    
	static var receiptSearchText: Font {
		return Font.custom("Segoe", size: 13)
	}
	
	static var scanningReceiptTitleFont: Font {
		return Font.custom("SFProDisplay-Regular", size: 20)
	}
	
	static var scanningReceiptCaptionFont: Font {
		return Font.custom("SFProDisplay-Regular", size: 12)
	}
	
	static var scanningReceiptCancelFont: Font {
		return Font.custom("SFProDisplay-Regular", size: 16)
	}
	
	static var manualReviewCommentLabel: Font {
		return Font.custom("SFProDisplay-Regular", size: 13)
	}
	
	static var manualReviewTitleLabel: Font {
		return Font.custom("SFProDisplay-Bold", size: 16)
	}
    
    static var errorMessageText: Font {
        return Font.custom("SFProText-Regular", size: 14)
    }
    
    /// Game Zone Card
    static var gameTitle: Font {
        return Font.custom("SFPro-Bold", size: 13)
    }
    
    /// Spin a wheel
    static var gameHeaderTitle: Font {
        return Font.custom("SFPro-Bold", size: 24)
    }
    
    static var gameHeaderSubTitle: Font {
        return Font.custom("SFPro-Medium", size: 16)
    }
    
    static var gameDescTitle: Font {
        return Font.custom("SFPro-Heavy", size: 16)
    }
    
    static var gameDescText: Font {
        return Font.custom("SFPro-Regular", size: 16)
    }
    
    /// Scratch Card
    static var scratchText: Font {
        return Font.custom("SFProDisplay-Regular", size: 12)
    }
    
    /// Order Placed - Game Zone
    static var orderPlacedTitle: Font {
        return Font.custom("SFProDisplay-Regular", size: 22).weight(.bold)
    }
    
    static var orderPlacedDescription: Font {
        return Font.custom("SFProDisplay-Regular", size: 14)
    }
    
    static var unlockedGameTitle: Font {
        return Font.custom("SFProDisplay-Regular", size: 16).weight(.bold)
    }
    
    static var unlockedGameDescription: Font {
        return Font.custom("SFProDisplay-Regular", size: 12)
    }
    
    static var footerButtonText: Font {
        return Font.custom("SFProDisplay-Regular", size: 16)
    }

    /// Game NoLuck View
    static var betterLuckText: Font {
        return Font.custom("SFProDisplay-Bold", size: 24)
    }
}
