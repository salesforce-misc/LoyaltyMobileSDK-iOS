//
//  PreviewProvider.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/21/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

@MainActor
class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    let member = MemberModel(firstName: "Julia",
                             lastName: "Green",
                             email: "julia.green@gmail.com",
                             mobileNumber: "5556781234",
                             joinEmailList: true,
                             dateCreated: Date(),
                             enrollmentDetails: EnrollmentDetails(loyaltyProgramMemberId: "0lM4x000000LECA",
                                                                  loyaltyProgramName: "NTO Insider",
                                                                  membershipNumber: "24345671"))
    let rootVM = AppRootViewModel()
    let benefitVM = BenefitViewModel()
    
    private init() {
        setMember(member: member)
    }
    
    func setMember(member: MemberModel) {
        self.rootVM.member = member
    }
    
}
