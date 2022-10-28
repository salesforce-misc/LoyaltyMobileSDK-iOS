//
//  MoreHeaderView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import SwiftUI

struct MoreHeaderView: View {
    
    @EnvironmentObject private var viewModel: AppRootViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("img-profile")
                Spacer()
            }
            
            Text("\(viewModel.member?.firstName.capitalized ?? "") \(viewModel.member?.lastName.capitalized ?? "")")
                .font(.nameText)
        }
    }
}

struct MoreHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MoreHeaderView()
            .environmentObject(dev.rootVM)
            .previewLayout(.sizeThatFits)
    }
}

