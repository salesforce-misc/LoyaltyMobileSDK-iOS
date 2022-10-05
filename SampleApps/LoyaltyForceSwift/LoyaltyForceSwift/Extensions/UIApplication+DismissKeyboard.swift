//
//  UIApplication+DismissKeyboard.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/5/22.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
