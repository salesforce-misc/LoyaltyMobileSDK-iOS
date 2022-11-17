//
//  PromotionDetailView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/11/22.
//

import SwiftUI

struct PromotionDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var promotionVM: PromotionViewModel
    @Binding var currentIndex: Int
    
    var body: some View {
        
        let promotion = promotionVM.promotions[currentIndex]
        
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                Image(promotion.imageName ?? "offers")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .overlay(alignment: .topTrailing) {
                        Image("ic-dismiss")
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(promotion.promotionName)
                        .font(.voucherTitle)

                    if let desc = promotion.description {
                        Text("**Details**\n\(desc)")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                            .lineSpacing(5)
                    }
                    
                    if let endDate = promotion.endDate {
                        Text("Expiring on **\(endDate)**")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                    }
                    
//                    Text("**Terms and Conditions**\n\(offer.offerDescription)")
//                        .font(.voucherText)
//                        .foregroundColor(Color.theme.superLightText)
//                        .lineSpacing(5)
                    Spacer()
                    if promotion.memberEligibilityCategory == "EligibleButNotEnrolled" {
                        HStack {
                            Spacer()
                            Button("Join") {
                                // enroll to the promotion
                            }
                            .buttonStyle(DarkShortButton())
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button("Close") {
                                dismiss()
                            }
                            .buttonStyle(DarkShortButton())
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .zIndex(3.0)
        
    }
}

struct PromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionDetailView(currentIndex: .constant(1))
    }
}
