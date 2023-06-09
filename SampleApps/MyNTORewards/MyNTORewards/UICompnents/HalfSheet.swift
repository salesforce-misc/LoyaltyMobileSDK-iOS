//
//  HalfSheet.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/27/22.
//

import SwiftUI

class HalfSheetController<Content>: UIHostingController<Content> where Content: View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium()]
            // presentation.prefersGrabberVisible = true
            // presentation.largestUndimmedDetentIdentifier = .medium // This will cause TabView losing accent color of selected tab
            presentation.preferredCornerRadius = 20.0
            presentation.selectedDetentIdentifier = .medium
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content: View {

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {
    }
}
