//
//  FontStyles.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/7/22.
//

import Foundation
import SwiftUI

extension Font {
    
    /// Shared
    
    /// Already a member? Not a member?
    static var footerText: Font {
        return Font.custom("SFPro-Regular", size: 16)
    }
    
    /// button texts or modal title texts
    static var buttonText: Font {
        return Font.custom("SFPro-Semibold", size: 16)
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
        return Font.custom("SFPro-Regular", size: 16)
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
    
    /// Redeem Card
    static var redeemTitle: Font {
        return Font.custom("SFPro-Medium", size: 14)
    }
    
    static var redeemText: Font {
        return Font.custom("SFPro-Regular", size: 12)
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
}
