//
//  String+StringWidth.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/9/22.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    
    // Get length of string on screen for centain font/weight
    func stringWidth(for font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func validateExpression(expression: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", expression)
        return predicate.evaluate(with: self)
    }
    
}
