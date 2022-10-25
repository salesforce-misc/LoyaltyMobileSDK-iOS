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
    private init() {}
    
    let rootVM = AppRootViewModel()
    let benefitVM = BenefitViewModel()
    
}
