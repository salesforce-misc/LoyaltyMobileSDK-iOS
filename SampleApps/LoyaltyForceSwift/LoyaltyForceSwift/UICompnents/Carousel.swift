//
//  Carousel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/7/22.
//

import Foundation
import SwiftUI

struct Carousel<Content: View, T: Identifiable>: View {
    
    let content: (T) -> Content
    let items: [T]
    let contentWidth: CGFloat
    
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(contentWidth: CGFloat = 320, // 320 = PromotionCardView().width
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T) -> Content) {
        
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
                
                VStack {
                    HStack(spacing: spacing) {
                        ForEach(items) { item in
                            content(item)
                                .frame(minWidth: contentWidth, maxWidth: proxy.size.width)
                        }
                    }
                    .padding(.horizontal, spacing)
                    .offset(x: currentIndex == 0 ? (0 + offset) : ((CGFloat(currentIndex) * -width) + adjustmentWidth + offset))
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                out = value.translation.width
                            })
                            .onEnded({ value in
                                let offsetX = value.translation.width
                                let progress = -offsetX / width
                                let roundIndex = progress.rounded()
                                currentIndex = max(min(currentIndex + Int(roundIndex), items.count - 1), 0)
                                currentIndex = index
                            })
                            .onChanged({ value in
                                let offsetX = value.translation.width
                                let progress = -offsetX / width
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
        PromotionCarouselView(selectedTab: .constant(.home))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
