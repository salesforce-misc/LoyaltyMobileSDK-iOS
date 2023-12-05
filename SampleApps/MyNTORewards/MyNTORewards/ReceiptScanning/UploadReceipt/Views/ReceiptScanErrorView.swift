//
//  ReceiptScanErrorView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 23/10/23.
//

import SwiftUI

struct ReceiptScanErrorView: View {
    var message: String?
    var bodyText: String?
    var scanStatus: ReceiptScanStatus = .receiptPartiallyReadable
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image("img-astronaut")
            VStack(alignment: .center, spacing: 20) {
                Group {
                    Text(getMessageText())
                    Text(getBodyText())
                }.font(.errorMessageText)
                    .foregroundColor(Color.theme.textInactive)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30)
            }
        }.frame(maxHeight: .infinity)
            .background(.white)
            .cornerRadius(4)
    }
	
    func getBodyText() -> String {
        if let bodyMessage = bodyText {
            return bodyMessage
        }
        return ""
    }
    
    func getMessageText() -> String {
        if let bodyMessage = message {
            return bodyMessage
        }
        var titleText = "We couldn’t process some items in the receipt."
        if scanStatus == .receiptNotReadable {
            titleText = "We couldn’t process the receipt."
        }
        return  titleText
    }
}

#Preview {
    ReceiptScanErrorView(scanStatus: .receiptNotReadable)
}
