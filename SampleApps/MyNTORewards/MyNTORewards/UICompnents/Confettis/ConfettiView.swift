//
//  ConfettiView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 26/10/23.
//

import SwiftUI

struct ConfettiView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = EmitterView()
        view.startConfetti()
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

#Preview {
    ConfettiView()
}
