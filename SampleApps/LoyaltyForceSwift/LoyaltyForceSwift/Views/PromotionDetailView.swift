//
//  PromotionDetailView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/11/22.
//

import SwiftUI

struct PromotionDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @Binding var currentIndex: Int
    @State private var processing = false
    
    var body: some View {
        
        let promotion = promotionVM.promotions[currentIndex]
        
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                Image(promotion.imageName ?? "img-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
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
                            Button("Enroll") {
                                // enroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.enroll(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "",
                                                           promotionName: promotion.promotionName)
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
                    } else if promotion.memberEligibilityCategory == "Eligible" && promotion.promotionEnrollmentRqr == true {
                        HStack {
                            Spacer()
                            Button("Unenroll") {
                                // unenroll to the promotion
                                processing = true
                                Task {
                                    do {
                                        try await promotionVM.unenroll(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "",
                                                           promotionName: promotion.promotionName)
                                        processing = false
                                    } catch {
                                        print("Unenroll in Promotion Error: \(error)")
                                        processing = false
                                    }
                                }

                            }
                            .buttonStyle(DarkShortButton())
                            .disabled(processing)
                            .opacity(processing ? 0.5 : 1)
                            
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
            
            if processing {
                ProgressView()
            }
        }
        .zIndex(3.0)
        
    }
}

struct PromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionDetailView(currentIndex: .constant(0))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.promotionVM)
    }
}
