//
//  Carousel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/7/22.
//

import Foundation
import SwiftUI

struct Carousel<Content: View, T: Identifiable>: View {
    
    let content: (String, T) -> Content
    let items: [T]
    let contentWidth: CGFloat
    
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(contentWidth: CGFloat = 320, // 320 = PromotionCardView().width
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (String, T) -> Content) {
        
        self.items = items
        self.contentWidth = contentWidth
        self._index = index
        self.content = content
    }
    
    var body: some View {
        
        VStack {
            GeometryReader { proxy in
                
                let trailingSpace = proxy.size.width - contentWidth
                let spacing = trailingSpace * 0.2
                let width = proxy.size.width - (trailingSpace - spacing)
                let adjustmentWidth = (trailingSpace / 2) - spacing
                
                let commonOffset = CGFloat(currentIndex) * -width + adjustmentWidth + offset
                let contentOffset = currentIndex == (items.count - 1) ? (commonOffset + adjustmentWidth) : commonOffset
                
                VStack {
                    HStack(spacing: spacing) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            content("promotion_\(index)", item)
                                .frame(minWidth: contentWidth, maxWidth: proxy.size.width)
                        }
                    }
                    .padding(.horizontal, spacing)
                    .offset(x: currentIndex == 0 ? offset : contentOffset)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                out = value.translation.width
                            })
                            .onEnded({ value in
                                let offsetX = value.translation.width
                                let progress = -offsetX / (width * 0.5)
                                let roundIndex = progress.rounded()
                                currentIndex = max(min(currentIndex + Int(roundIndex), items.count - 1), 0)
                                currentIndex = index
                            })
                            .onChanged({ value in
                                let offsetX = value.translation.width
                                let progress = -offsetX / (width * 0.5)
                                let roundIndex = progress.rounded()
                                index = max(min(currentIndex + Int(roundIndex), items.count - 1), 0)
                            })
                    )
                    
                }
            }
            .animation(.spring(), value: offset == 0)
        }
        
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCarouselView(selectedTab: .constant(Tab.home.rawValue))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
