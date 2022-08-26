//
//  BenefitView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/24/22.
//

import SwiftUI

struct BenefitView: View {
    
//    @StateObject private var viewModel = BenefitViewModel()
    
    var body: some View {
        Text("BenefitView")

        
//        VStack {
//            Text("Benefits")
//                .font(.headline)
//            let benefits: [MemberBenefitModel] = viewModel.benefits
//            ForEach(benefits) { benefit in
//                Text("\(benefit.benefitName)")
//            }
//        }
//        .task {
//            do {
//                try await viewModel.fetchBenefits()
//            } catch {
//                print("Fetch Benefits Error: \(error.localizedDescription)")
//            }
//
//        }
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView()
    }
}
