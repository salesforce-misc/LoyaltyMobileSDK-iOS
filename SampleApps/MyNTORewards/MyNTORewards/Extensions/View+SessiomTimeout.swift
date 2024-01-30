//
//  View+SessiomTimeout.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/12/24.
//

import SwiftUI

extension View {
    func autoSignOutOnSessionTimeout() -> some View {
        self.modifier(SessionTimeoutModifier())
    }
}

struct SessionTimeoutModifier: ViewModifier {
    @EnvironmentObject private var rootVM: AppRootViewModel

    func body(content: Content) -> some View {
        content
            .onChange(of: ForceAuthManager.shared.sessionTimeout) { timeout in
                if timeout {
                    // Perform the sign out action
                    rootVM.signOutUser()
                }
            }
    }
}
