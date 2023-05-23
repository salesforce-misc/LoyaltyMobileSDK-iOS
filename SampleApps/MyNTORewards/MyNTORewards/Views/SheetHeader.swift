//
//  SheetHeader.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/26/22.
//

import SwiftUI

struct SheetHeader: View {
    let title: String
    let onDismiss: () -> Void
    let alert: (() -> Alert)?

    @State private var showDismissAlert = false

    init(title: String, onDismiss: @escaping () -> Void, alert: (() -> Alert)? = nil) {
        self.title = title
        self.onDismiss = onDismiss
        self.alert = alert
    }

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .padding()

                Spacer()

                if let alert = alert {
                    Button(action: {
                        self.showDismissAlert = true
                    }) {
                        Image("ic-close")
                    }
                    .alert(isPresented: $showDismissAlert, content: alert)
                    .accessibilityIdentifier(title + "_dismiss")
                    .padding()

                } else {
                    Button(action: {
                        onDismiss()
                    }) {
                        Image("ic-close")
                    }
                    .accessibilityIdentifier(title + "_dismiss")
                    .padding()

                }
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
