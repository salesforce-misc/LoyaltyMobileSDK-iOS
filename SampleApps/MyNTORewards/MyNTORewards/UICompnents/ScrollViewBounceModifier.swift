//
//  ScrollViewBounceModifier.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 10/10/23.
//

import SwiftUI

struct ScrollViewBounceModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .scrollBounceBehavior(.basedOnSize)
        } else {
            content
        }
    }
}

extension View {
    func diableBounceForScrollView() -> some View {
        modifier(ScrollViewBounceModifier())
    }
}
