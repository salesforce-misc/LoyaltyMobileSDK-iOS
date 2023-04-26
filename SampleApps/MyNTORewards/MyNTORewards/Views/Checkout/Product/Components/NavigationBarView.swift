//
//  NavigationBarView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 14/03/23.
//

import SwiftUI

struct NavigationBarView: View {
    var body: some View {
		VStack(spacing: 0) {
			HStack {
				Image("ic-logo-home")
					.padding(.leading, 15)
				Spacer()
			}
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(Color.theme.accent)
		}
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView()
    }
}
