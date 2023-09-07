//
//  CircularButtonStyle.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/21/23.
//

import SwiftUI

struct CircularButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.white.opacity(0.5) : Color.clear)
            .clipShape(Circle())
    }
}
