//
//  AllBenefitsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct AllBenefitsView: View {
    
    let viewModel: BenefitViewModel
    
    var body: some View {
        
        ZStack {
            Color.theme.background
            
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.benefits) { benefit in
                        HStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .overlay(
                                    Image("return")
                                )
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("\(benefit.benefitName)")
                                        .font(.benefitText)
                                        .foregroundColor(Color.theme.accent)
                                    Spacer()
                                }

                                HStack {
                                    Text("\(viewModel.benefitDescs[benefit.id] ?? "")")
                                        .font(.benefitDescription)
                                        .lineSpacing(4)
                                        .foregroundColor(Color.theme.superLightText)
                                    Spacer()
                                }

                            }
                            
                        }
                        .padding()
                        
                        Divider()
                    }
                }
            }
            
            
        }
        .loytaltyNavigationTitle("Benefits")
    }
}

struct AllBenefitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllBenefitsView(viewModel: BenefitViewModel())
    }
}
