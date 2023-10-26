//
//  MyPromotionDetailView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/21/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct MyPromotionDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel

    let promotion: PromotionResult
    @Binding var processing: Bool
    
    var body: some View {
        
        let currentPromotion: PromotionResult = promotionVM.promotionList[promotion.id] ?? promotion
        
        ZStack {
            Color.white
            
            VStack(spacing: 20) {
                GeometryReader { geometry in
                    LoyaltyAsyncImage(url: promotion.promotionImageURL, content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }, placeholder: {
                        ProgressView()
                    })
                    .accessibilityIdentifier(AppAccessibilty.Promotion.image)
                    .frame(maxWidth: geometry.size.width, maxHeight: 220)
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        Image("ic-dismiss")
                            .accessibilityIdentifier(AppAccessibilty.Promotion.dismissButton)
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
                .frame(maxHeight: 220)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(currentPromotion.promotionName)
                        .font(.voucherTitle)
                        .accessibilityIdentifier(AppAccessibilty.Promotion.name)

                    if let desc = currentPromotion.description {
                        Text("**Details**\n\(desc)")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                            .lineSpacing(5)
                            .accessibilityIdentifier(AppAccessibilty.Promotion.description)
                    }
                    
                    if let endDate = currentPromotion.endDate {
                        Text("Expiring on **\(endDate)**")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                            .accessibilityIdentifier(AppAccessibilty.Promotion.endDate)
                    }
                    
                    Spacer()
                    if currentPromotion.memberEligibilityCategory == "EligibleButNotEnrolled" {
                        HStack {
                            Spacer()
                            Button("Opt In") {
                                // enroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.enroll(membershipNumber: rootVM.member?.membershipNumber ?? "",
                                                                     promotionName: currentPromotion.promotionName, promotionId: promotion.id)
                                        processing = false
                                    } catch {
                                        Logger.error("Enroll in Promotion Error: \(error)")
                                        processing = false
                                    }
                                }
                            }
                            .accessibilityIdentifier(AppAccessibilty.Promotion.joinButton)
                            .buttonStyle(DarkShortButton())
                            .disabled(processing)
                            .opacity(processing ? 0.5 : 1)
                            
                            Spacer()
                        }
                    } else if currentPromotion.memberEligibilityCategory == "Eligible" && currentPromotion.promotionEnrollmentRqr == true {
                        HStack {
                            Spacer()
                            Button("Shop") {
                                shopPromotion(promotion: currentPromotion)
                            }
                            .accessibilityIdentifier(AppAccessibilty.Promotion.shopButton)
                            .buttonStyle(DarkShortPromotionButton())
                            Spacer()
                            Button("Opt Out") {
                                // unenroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.unenroll(membershipNumber: rootVM.member?.membershipNumber ?? "",
                                                                       promotionName: currentPromotion.promotionName, promotionId: promotion.id)
                                        processing = false
                                    } catch {
                                        Logger.error("Unenroll in Promotion Error: \(error)")
                                        processing = false
                                    }
                                }
                            }
                            .accessibilityIdentifier(AppAccessibilty.Promotion.leaveButton)
                            .buttonStyle(LightShortPromotionButton())
                            .disabled(processing)
                            .opacity(processing ? 0.5 : 1)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button("Shop") {
                                // link to e-commerce
                                shopPromotion(promotion: currentPromotion)
                            }
                            .accessibilityIdentifier(AppAccessibilty.Promotion.shopButton)
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
            
            if processing {
                ProgressView()
            }
        }
        .zIndex(3.0)
        
    }
	
    private func shopPromotion(promotion: PromotionResult) {
        if promotion.promotionName == "Gold Tier Rejuvenation" {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                promotionVM.isCheckoutNavigationActive = true
            }
        }
    }
}

struct MyPromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
		MyPromotionDetailView(promotion: dev.promotion, processing: .constant(false))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
            .environmentObject(dev.imageVM)
    }
}
