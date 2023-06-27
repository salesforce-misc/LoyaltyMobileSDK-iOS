//
//  RevealableSecureField.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/23/22.
//

import SwiftUI

struct RevealableSecureField: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        Group {
            if isSecured {
                SecureField(title, text: $text)
                    .disableAutocorrection(true)
                    .textFieldStyle(RegularTextFieldStyle())
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image("ic-preview")
                                    .opacity(text.isEmpty ? 0 : 1)
                            }
                            .disabled(text.isEmpty)
                        }
                        .padding(.trailing, 25)
                    )
            } else {
                TextField(title, text: $text)
                    .disableAutocorrection(true)
                    .textFieldStyle(RegularTextFieldStyle())
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image("ic-hide")
                                    .opacity(text.isEmpty ? 0 : 1)
                            }
                            .disabled(text.isEmpty)
                        }
                        .padding(.trailing, 25)
                    )
            }
        }
    }
}

struct RevealableSecureField_Previews: PreviewProvider {
    static var previews: some View {
        RevealableSecureField("Password", text: .constant("somepassword"))
            .previewLayout(.sizeThatFits)
    }
}
