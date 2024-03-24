//
//  AdminMenuView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/11/23.
//

import SwiftUI

struct AdminMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ConnectedAppsView()) {
                    Text("Connected App")
                }
                NavigationLink(destination: AdminAppSettingsView()) {
                    Text("App Settings")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
