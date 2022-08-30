//
//  BenefitView.swift
//  LoyaltyMobile
//
//  Created by Leon Qi on 8/24/22.
//

import SwiftUI
import SwiftlySalesforce

struct BenefitView: View {
    
    @EnvironmentObject var salesforce: Connection
    @StateObject private var viewModel = BenefitViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Benefits")
                    .font(.headline)
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
                try await viewModel.fetchBenefits(connection: salesforce)
            } catch {
                print("Fetch Benefits Error: \(error.localizedDescription)")
            }

        }
    }

}


struct BenefitView_Previews: PreviewProvider {
    static var previews: some View {
        BenefitView().environmentObject(try! Salesforce.connect())
    }
}
