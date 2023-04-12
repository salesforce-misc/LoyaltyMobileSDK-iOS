//
//  TopTabBar.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/9/22.
//

import SwiftUI

struct TopTabBar: View, Equatable {
	
	enum TabAlignment {
		case left
		case center
	}

    let barItems: [String]
	let tabAlignment: TabAlignment
    @Binding var tabIndex: Int
    @Namespace private var namespace
	
	init(barItems: [String], tabIndex: Binding<Int>, tabAlignment: TabAlignment = .left) {
		self.barItems = barItems
		self._tabIndex = tabIndex
		self.tabAlignment = tabAlignment
	}
    
    var body: some View {
		HStack(spacing: getSpacing()) {
            ForEach(0..<barItems.count, id: \.self) { index in
                let lableText = barItems[index]
                ZStack(alignment: .bottom){
                    if(tabIndex == index) {
                        Capsule()
                            .fill(Color.theme.accent)
                            .matchedGeometryEffect(id: "offer_underscore", in: namespace, properties: .frame)
                            .frame(width: 20 + lableText.stringWidth(), height: 4)
                            .offset(y: 20)
							.animation(SwiftUI.Animation.easeIn, value: tabIndex)
                    }
                    Text(lableText)
                        .font(.offersTabSelected)
                        .foregroundColor(tabIndex == index ? Color.theme.accent : Color.theme.textInactive)
                        .frame(width: 20 + lableText.stringWidth(), height: 4)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        tabIndex = index
                    }
                }
				if tabAlignment == .center {
					Spacer()
				}
            }
			if tabAlignment == .left {
				Spacer()
			}
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .padding(.leading)
        .background(Color.white)
    }
    
    static func == (lhs: TopTabBar, rhs: TopTabBar) -> Bool {
        return lhs.barItems == rhs.barItems
    }
	
	func getSpacing() -> CGFloat {
		switch tabAlignment {
			case .center:
				return 16
			case .left:
				return 30
		}
	}
}

struct TopTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(0))
		TopTabBar(barItems: ["Available", "Redeemed", "Expired"], tabIndex: .constant(1), tabAlignment: .center)

    }
}
