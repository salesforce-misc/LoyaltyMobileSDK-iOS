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
//	@Binding var shopTapped: Bool
    
    var body: some View {
        
        let currentPromotion: PromotionResult = promotionVM.promotionList[promotion.id] ?? promotion
        
        ZStack {
            Color.white
            
            VStack {
                AsyncImageView(imageUrl: promotion.promotionImageURL)
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        Image("ic-dismiss")
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(currentPromotion.promotionName)
                        .font(.voucherTitle)

                    if let desc = currentPromotion.description {
                        Text("**Details**\n\(desc)")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                            .lineSpacing(5)
                    }
                    
                    if let endDate = currentPromotion.endDate {
                        Text("Expiring on **\(endDate)**")
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                    }
                    
                    Spacer()
                    if currentPromotion.memberEligibilityCategory == "EligibleButNotEnrolled" {
                        HStack {
                            Spacer()
                            Button("Join") {
                                // enroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.enroll(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "",
                                                                     promotionName: currentPromotion.promotionName, promotionId: promotion.id)
                                        processing = false
                                    } catch {
                                        print("Enroll in Promotion Error: \(error)")
                                        processing = false
                                    }
                                }
                            }
                            .buttonStyle(DarkShortButton())
                            .disabled(processing)
                            .opacity(processing ? 0.5 : 1)
                            
                            Spacer()
                        }
                    } else if currentPromotion.memberEligibilityCategory == "Eligible" && currentPromotion.promotionEnrollmentRqr == true {
                        HStack {
                            Spacer()
                            Button("Shop") {
                                dismiss()
//								shopTapped = true
								promotionVM.shopPromotion()
                            }
                            .buttonStyle(DarkShortPromotionButton())
                            Spacer()
                            Button("Leave") {
                                // unenroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.unenroll(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "",
                                                                       promotionName: currentPromotion.promotionName, promotionId: promotion.id)
                                        processing = false
                                    } catch {
                                        print("Unenroll in Promotion Error: \(error)")
                                        processing = false
                                    }
                                }
                            }
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
            
            if processing {
                ProgressView()
            }
        }
        .zIndex(3.0)
        
    }
}

struct MyPromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
		MyPromotionDetailView(promotion: dev.promotion, processing: .constant(false))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
