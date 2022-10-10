//
//  BenefitView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/24/22.
//

import SwiftUI

struct BenefitView: View {
    
    @StateObject private var viewModel = BenefitViewModel()
    //private let memberId: String = "0lM5i00000000KfEAI"
    private let memberId: String = "0lM4x000000LECA"
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Text("Benefits")
                        .font(.offerTitle)
                        .foregroundColor(.black)
                    Spacer()
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                        .onTapGesture {
                            print("clicked")
                            withAnimation {
                                //
                            }
                            
                        }
                }
                .padding()
                
                let benefits: [BenefitModel] = viewModel.benefits

                ForEach(benefits) { benefit in
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
                            //.padding([.horizontal, .top])
                            HStack {
                                Text("\(viewModel.benefitDescs[benefit.id] ?? "")")
                                    .font(.benefitDescription)
                                    .lineSpacing(4)
                                    .foregroundColor(Color.theme.superLightText)
                                Spacer()
                            }
                            //.padding([.horizontal, .bottom])
                        }
                        
                    }
                    .padding()
                    
                    Divider()
                }
                
            }
            .frame(height: 400)
            .task {
                do {
                    try await viewModel.getBenefits(memberId: memberId)
                } catch {
                    print("Fetch Benefits Error: \(error)")
                }

            }
            
            if !viewModel.isLoaded {
                ProgressView()
            }

        }
        
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView()
    }
}
