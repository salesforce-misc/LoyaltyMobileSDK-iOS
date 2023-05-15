//
//  SheetHeader.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/26/22.
//

import SwiftUI

struct SheetHeader: View {

    let title: String
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.boldedText)
                    .padding()
                    .accessibilityIdentifier(title)
                Spacer()
                Button {
                    onDismiss()
                } label: {
                    Image("ic-close")
                }
                .accessibilityIdentifier(title + "_dismiss")
                .padding()
            }
            .padding(.top)
            Divider()
        }
    }
}

struct SheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        SheetHeader(title: "Log In", onDismiss: {})
            .previewLayout(.sizeThatFits)
    }
}
