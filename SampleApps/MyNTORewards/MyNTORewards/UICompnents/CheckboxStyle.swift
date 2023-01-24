//
//  CheckboxStyle.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/18/22.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? Color.theme.accent : .gray)
            configuration.label
                .font(.regularText)
                .foregroundColor(Color.theme.lightText)
            Spacer()
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }

    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        Toggle(isOn: .constant(true)) {
            Text("The label")
        }
        .toggleStyle(CheckboxStyle())
    }
}
