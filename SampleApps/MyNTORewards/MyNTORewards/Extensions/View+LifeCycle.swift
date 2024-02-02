//
//  View+LifeCycle.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 22/12/23.
//

import UIKit
import SwiftUI

extension View {
	func onWillAppear(_ perform: @escaping () -> Void) -> some View {
		modifier(WillAppearModifier(callback: perform))
	}
}

struct WillAppearModifier: ViewModifier {
	let callback: () -> Void
	
	func body(content: Content) -> some View {
		content.background(UIViewLifeCycleHandler(onWillAppear: callback))
	}
}

struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIViewController
	
	var onWillAppear: () -> Void = { }
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
		context.coordinator
	}
	
	func updateUIViewController(
		_: UIViewControllerType,
		context _: UIViewControllerRepresentableContext<Self>
	) { }
	
	func makeCoordinator() -> Self.Coordinator {
		Coordinator(onWillAppear: onWillAppear)
	}
	
	class Coordinator: UIViewControllerType {
		let onWillAppear: () -> Void
		
		init(onWillAppear: @escaping () -> Void) {
			self.onWillAppear = onWillAppear
			super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			onWillAppear()
		}
	}
}
