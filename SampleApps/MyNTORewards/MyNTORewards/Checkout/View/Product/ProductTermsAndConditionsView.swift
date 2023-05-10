//
//  ProductTermsAndConditionsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ProductTermsAndConditionsView: View {
    var body: some View {
        HStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("Terms and Conditions")
                            .font(.title3)
                            .padding()
                        Spacer()
                    }
                    ForEach(termsAndConditions, id: \.self) { term in
                        Text(term)
                            .font(.footnote)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                    }
                }
                .padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.all)
            Spacer()
        }
    }

    // swiftlint:disable line_length
    let termsAndConditions = [
        "1. Program Eligibility: The MyNTORewards Loyalty Program (\"Program\") is open to individuals who are at least 18 years of age and have an active MyNTORewards account. By participating in the Program, members (\"Members\") agree to abide by these Terms and Conditions.",
        
        "2. Enrollment: To enroll in the Program, individuals must create a MyNTORewards account on our website or through our mobile application. Enrollment is free, and no purchase is required to become a Member.",
        
        "3. Earning Points: Members earn rewards points (\"Points\") by making qualifying purchases at participating locations or through the MyNTORewards website. Points are awarded based on the total purchase amount, excluding taxes and shipping fees. The rate at which Points are earned may vary and is subject to change at any time without prior notice.",
        
        "4. Redeeming Points: Members may redeem their accumulated Points for merchandise available on the MyNTORewards shopping site. The number of Points required to redeem each item will be displayed alongside the product. Points may not be redeemed for cash, gift cards, or any other form of currency.",
        
        "5. Point Expiration: Points will expire if a Member's account has been inactive for 12 consecutive months. Account inactivity is defined as not earning or redeeming Points during the specified timeframe. Expired Points cannot be reinstated or transferred.",
        
        "6. Returns and Exchanges: Items purchased using Points may be returned or exchanged within 14 days of receipt, provided that they are in new and unused condition, with all original packaging and tags intact. Members are responsible for any shipping costs associated with returns or exchanges.",
        
        "7. Account Termination: MyNTORewards reserves the right to terminate a Member's account and forfeit any accumulated Points if it determines, in its sole discretion, that the Member has violated these Terms and Conditions, engaged in fraudulent or abusive behavior, or otherwise acted in bad faith.",
        
        "8. Modification of Terms: MyNTORewards may modify these Terms and Conditions at any time, with or without prior notice. Any changes to the Terms and Conditions will be posted on the MyNTORewards website. Continued participation in the Program constitutes acceptance of any modified terms.",
        
        "9. Privacy Policy: MyNTORewards values your privacy and is committed to protecting your personal information. Please review our Privacy Policy to learn more about how we collect, use, and disclose your information.",
        
        "10. Limitation of Liability: By participating in the Program, Members agree to release MyNTORewards and its affiliates, partners, and subsidiaries from any and all liability arising from the Program, including but not limited to, the earning and redemption of Points and the use of redeemed merchandise. MyNTORewards is not responsible for any errors, omissions, or technical issues that may affect a Member's ability to earn or redeem Points.",
        
        "11. Governing Law: The Program and these Terms and Conditions are governed by the laws of the jurisdiction in which the participating location is situated, without regard to its conflict of law provisions. Members agree to submit to the exclusive jurisdiction of the courts located within the same jurisdiction for the resolution of any disputes arising from the Program or these Terms and Conditions."
    ]
    // swiftlint:enable line_length

}

struct ProductTermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductTermsAndConditionsView()
    }
}
