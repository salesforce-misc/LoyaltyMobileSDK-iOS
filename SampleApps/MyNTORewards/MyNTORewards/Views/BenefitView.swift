//
//  BenefitView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct BenefitView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var benefitVM: BenefitViewModel
    
    var body: some View {
        
        let benefits: [BenefitModel] = benefitVM.benefitsPreview
        
        ZStack {
            
            ViewAllView(title: "My Benefits") {
                AllBenefitsView()
            } content: {
                if benefits.isEmpty {
                    EmptyStateView(title: "You have no Benefits")
                }
                ForEach(benefits) { benefit in
                    HStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .overlay(
                                Assets.getBenefitsLogo(for: benefit.benefitTypeName)
                                    .renderingMode(.template)
                                    .foregroundColor(Color.theme.accent)
                            )

                        VStack(spacing: 5) {
                            HStack {
                                Text("\(benefit.benefitName)")
                                    .font(.benefitText)
                                    .foregroundColor(Color.theme.accent)
                                Spacer()
                            }

                            HStack {
                                Text("\(benefitVM.benefitDescs[benefit.id] ?? "")")
                                    .font(.benefitDescription)
                                    .lineSpacing(3)
                                    .foregroundColor(Color.theme.superLightText)
                                Spacer()
                            }

                        }

                    }
                    .padding()

                    Divider()
                        .padding(.horizontal)
                }
                Spacer()
            }
            .frame(height: 520)
            .task {
                do {
                    try await benefitVM.getBenefits(memberId: rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? "")
                } catch {
                    print("Fetch Benefits Error: \(error)")
                }

            }
            
            if !benefitVM.isLoaded {
                ProgressView()
            }
            
        }
        
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.benefitVM)
    }
}
