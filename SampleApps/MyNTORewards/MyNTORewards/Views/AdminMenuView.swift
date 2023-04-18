//
//  AdminMenuView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/11/23.
//

import SwiftUI

struct AdminMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: ConnectedAppsView()) {
                        Text("Connected App")
                    }
                }
                Spacer()
            }
            .navigationTitle("Settings")
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
