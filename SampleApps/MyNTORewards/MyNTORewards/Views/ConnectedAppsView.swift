//
//  ConnectedAppsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/11/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ConnectedAppsView: View {
    
    @EnvironmentObject private var connectedAppVM: ConnectedAppsViewModel
    
    @State private var selectedApp: ForceConnectedApp = AppSettings.shared.getConnectedApp()
    @State private var showAddOther: Bool = false

    var body: some View {
        List {
            Section {
                
                HStack {
                    ZStack(alignment: .leading) {
                        Text("\(selectedApp.connectedAppName)")
                            .padding(.leading, 15) // Add padding to the Text to adjust spacing
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.theme.accent)
                                .offset(x: -10, y: 0) // Adjust the x value for desired spacing
                            Spacer()
                        }
                    }
                    .overlay(
                        NavigationLink {
                            ConnectedAppSettingsView(name: selectedApp.connectedAppName,
                                                     consumerKey: selectedApp.consumerKey,
                                                     consumerSecret: selectedApp.consumerSecret,
                                                     callbackURL: selectedApp.callbackURL,
                                                     baseURL: selectedApp.baseURL,
                                                     instanceURL: selectedApp.instanceURL,
                                                     communityURL: selectedApp.communityURL,
                                                     selfRegisterURL: selectedApp.selfRegisterURL)
                        } label: {
                            
                        }
                        .opacity(0)
                    )
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.theme.accent)
                }
                
            } header: {
                Text("Selected Conected App")
            }
            
            Section {
                ForEach(connectedAppVM.savedApps, id: \.self) { app in
                    if app.instanceURL != connectedAppVM.selectedInstance {
                        InfoNavigationLink(
                            destination: ConnectedAppSettingsView(
                                name: app.connectedAppName,
                                consumerKey: app.consumerKey,
                                consumerSecret: app.consumerSecret,
                                callbackURL: app.callbackURL,
                                baseURL: app.baseURL,
                                instanceURL: app.instanceURL,
                                communityURL: app.communityURL,
                                selfRegisterURL: app.selfRegisterURL),
                            action: {
                                selectedApp = app
                                connectedAppVM.selectedInstance = app.instanceURL
                                connectedAppVM.updateSavedApps()
                        }) {
                            ZStack(alignment: .leading) {
                                Text(app.connectedAppName)
                                    .padding(.leading, 15) // Add padding to the Text to adjust spacing
                                HStack {
                                    // Empty HStack to keep text aligned
                                    Spacer()
                                }
                            }

                        }
                        
                    }
                    
                }
                .onDelete(perform: deleteItem)
                
                ZStack(alignment: .leading) {
                    Button("Other...") {
                        showAddOther.toggle()
                    }
                    .buttonStyle(FullWidthButtonStyle())
                    .padding(.leading, 15) // Add padding to the Text to adjust spacing
                    HStack {
                        // Empty HStack to keep text aligned
                        Spacer()
                    }
                }
                
            } header: {
                Text("My Connected Apps")
            }

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            selectedApp = connectedAppVM.retrieveApp(instance: connectedAppVM.selectedInstance) ?? AppSettings.shared.getConnectedApp()
        }
        .sheet(isPresented: $showAddOther) {
            ConnectedAppSettingsView(isAddingNew: true,
                                     name: "",
                                     consumerKey: "",
                                     consumerSecret: "",
                                     callbackURL: "",
                                     baseURL: "",
                                     instanceURL: "",
                                     communityURL: "",
                                     selfRegisterURL: "")
        }

    }

    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let app = connectedAppVM.savedApps.remove(at: index)
            connectedAppVM.deleteApp(connectedApp: app)
        }
        
    }

}

struct ConnectedAppsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedAppsView()
    }
}

struct FullWidthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary) // Set the label color to regular text color
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())

    }
}
