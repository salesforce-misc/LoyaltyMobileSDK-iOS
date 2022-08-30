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
        VStack(alignment: .leading) {
            Text("Benefits")
                .font(.headline)
            let benefits: [BenefitModel] = viewModel.benefits
            ForEach(benefits) { benefit in
                Text("\(benefit.benefitName)")
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
