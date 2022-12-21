//
//  FullSheet.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/30/22.
//

import SwiftUI

class FullSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.large()]
            //presentation.prefersGrabberVisible = true
            //presentation.largestUndimmedDetentIdentifier = .medium
            presentation.preferredCornerRadius = 20.0
            presentation.selectedDetentIdentifier = .large
        }
    }
}

struct FullSheet<Content>: UIViewControllerRepresentable where Content : View {

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> FullSheetController<Content> {
        return FullSheetController(rootView: content)
    }
    
    func updateUIViewController(_: FullSheetController<Content>, context: Context) {
    }
}
