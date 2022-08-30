//
//  BenefitView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/24/22.
//

import SwiftUI

struct BenefitView: View {
    
    @StateObject private var viewModel = BenefitViewModel()
    private let memberId: String = "0lM5i00000000KfEAI"
    
    var body: some View {
        VStack {
            HStack {
                Text("Benefits")
                    .font(.headline)
                    .foregroundColor(Color.theme.titleColor)
                Spacer()
                Text("View All")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.darkBlue)
            }
            .padding()
            
            
            if !viewModel.isLoaded {
                ProgressView()
            }
            
            let benefits: [BenefitModel] = viewModel.benefits

            ForEach(benefits) { benefit in
                HStack {
                    Text("\(benefit.benefitName)")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.lightBlue)
                    Spacer()
                }
                .padding(.horizontal)
                HStack {
                    Text("This is benefit description. We need description here but it's currently not provided by the API call.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.accent)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
            }
            
        }
        .task {
            do {
                try await viewModel.fetchBenefits(memberId: memberId)
            } catch {
                print("Fetch Benefits Error: \(error.localizedDescription)")
            }

        }
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView()
    }
}
