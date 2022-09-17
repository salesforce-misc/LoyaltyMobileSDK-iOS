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
    @State var benefitDesc: String?
    
    var body: some View {
        VStack {
            HStack {
                Text("Benefits")
                    .font(.headline)
                    .foregroundColor(Color.theme.titleColor)
                Spacer()
                Text("View All")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
            }
            .padding()
            
            
            if !viewModel.isLoaded {
                ProgressView()
            }
            
            let benefits: [BenefitModel] = viewModel.benefits

            ForEach(benefits) { benefit in
                HStack {
                    Text("\(benefit.benefitName)")
                        .font(.benefitText)
                        .foregroundColor(Color.theme.accent)
                        .lineSpacing(5)
                    Spacer()
                }
                .padding(.horizontal)
                HStack {
                    Text("\(viewModel.benefitDescs[benefit.id] ?? "")")
                        .font(.benefitDescription)
                        .foregroundColor(Color.theme.superLightText)
                        .lineSpacing(5)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                Divider()
            }
            
        }
        .padding()
        .task {
            do {
                try await viewModel.getBenefits(memberId: memberId)
            } catch {
                print("Fetch Benefits Error: \(error)")
            }

        }
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView()
    }
}
