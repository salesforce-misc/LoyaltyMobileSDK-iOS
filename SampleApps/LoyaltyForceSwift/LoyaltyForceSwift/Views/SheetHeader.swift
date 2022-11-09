//
//  SheetHeader.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/26/22.
//

import SwiftUI

struct SheetHeader: View {
    
    @Environment(\.dismiss) private var dismiss

    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.boldedText)
                    .padding()
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image("ic-close")
                }
                .padding()

            }
            .padding(.top)
            Divider()
        }
    }
}

struct SheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        SheetHeader(title: "Log In")
            .previewLayout(.sizeThatFits)
    }
}
