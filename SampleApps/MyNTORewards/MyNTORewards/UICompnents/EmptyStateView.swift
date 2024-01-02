//
//  EmptyStateView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/1/22.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String?
    let subTitle: String?
    
    init(title: String? = nil, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
    
    var body: some View {
        VStack {
            Image("img-empty-state")
            
            VStack(spacing: 8) {
				if let title = title {
					Text(title)
						.accessibility(identifier: title)
						.font(.emptyStateTitle)
				}
                if let subTitle = subTitle {
                    Text(subTitle)
                        .font(.emptyStateSubTitle)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 45)
                        .accessibilityIdentifier(subTitle)
                }
            }
            
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "You have no Promotions",
                       subTitle: "You do not have any eligibile promotions to enroll. Please come back later.")
    }
}
