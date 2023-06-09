//
//  TermsAndConditionsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 5/12/23.
//

import SwiftUI

struct TermsAndConditionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Terms and Conditions") {
                dismiss()
            }
            ScrollView {
                VStack {
                    
                    // swiftlint:disable line_length
                    Text("""
                    1. Introduction
                    
                    1.1. These Terms & Conditions ("Terms") govern the MyNTORewards Loyalty Program ("Program") offered by MyNTO Ltd. ("MyNTO," "we," "us," or "our"). By participating in the Program, you ("Member," "you," or "your") agree to be bound by these Terms, as well as our Privacy Policy, incorporated herein by reference.

                    1.2. We reserve the right, at our sole discretion, to modify or update these Terms at any time without prior notice. Your continued participation in the Program after any such changes constitutes your acceptance of the new Terms.

                    2. Membership Eligibility and Enrollment
                    
                    2.1. The Program is open to individuals who are 18 years of age or older and have a valid email address.

                    2.2. To enroll in the Program, you must provide your full name, email address, and any other required information.

                    2.3. There is no cost to join the Program.

                    3. Earning MyNTORewards Points
                    
                    3.1. Members can earn MyNTORewards Points ("Points") by making qualifying purchases at participating MyNTO locations or through our website and mobile app.

                    3.2. Points will be credited to your account within 24 hours of your qualifying purchase.

                    3.3. The number of Points earned per qualifying purchase may vary and will be determined by us at our sole discretion.

                    3.4. Points are non-transferable, have no cash value, and may not be combined with any other offers, discounts, or promotions.

                    4. Redeeming Points
                    
                    4.1. Members can redeem Points for rewards ("Rewards") available through the Program.

                    4.2. The number of Points required to redeem a Reward may vary and will be determined by us at our sole discretion.

                    4.3. Rewards are subject to availability and may be substituted or discontinued at any time without prior notice.

                    4.4. Rewards cannot be exchanged, returned, or refunded for Points, cash, or any other form of credit.

                    5. Account Management
                    
                    5.1. You are responsible for maintaining the confidentiality of your account information, including your password.

                    5.2. Any unauthorized use of your account or any other breach of security must be reported to us immediately.

                    5.3. We reserve the right to suspend or terminate your account and participation in the Program if we determine, at our sole discretion, that you have violated these Terms.

                    6. Expiration and Termination
                    
                    6.1. Points will expire 48 months from the date they were earned.

                    6.2. We reserve the right to terminate the Program or your participation in the Program at any time, for any reason, without prior notice.

                    7. Limitation of Liability
                    
                    7.1. We are not responsible for any damages or losses arising from your participation in the Program, including, but not limited to, any errors, delays, or failures in the issuance, redemption, or use of Points or Rewards.

                    8. Governing Law
                    
                    8.1. These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which MyNTO is registered, without regard to its conflict of law provisions.

                    9. Contact Us
                    
                    9.1. If you have any questions or concerns about the Program or these Terms, please contact us at support@mynstorewards.com.
                    
                    
                    """)
                    .padding()
                    // swiftlint:enable line_length
            }
            
            }
        }
        
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}
