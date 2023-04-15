//
//  ConnectedAppSettingsModalView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/11/23.
//

import SwiftUI
import LoyaltyMobileSDK
import Combine

struct ConnectedAppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var connectedAppVM: ConnectedAppsViewModel
    
    @FocusState private var nameIsFocused: Bool
    @State var isAddingNew: Bool = false
    @State private var isEditing: Bool = false {
        didSet {
            if isEditing {
                DispatchQueue.main.async {
                    nameIsFocused = true
                }
            }
        }
    }
    
    @State var name: String
    @State var consumerKey: String
    @State var consumerSecret: String
    @State var callbackURL: String
    @State var baseURL: String
    @State var instanceURL: String
    @State var communityURL: String
    
    private let focusPublisher = PassthroughSubject<Void, Never>()
    
    var body: some View {
        
        VStack(spacing: 0) {
            if isAddingNew {
                VStack {
                    Text("Enter Connected App Information")
                        .font(.system(size: 10))
                    Spacer()
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        Spacer()
                        Text("Other")
                        Spacer()
                        Button("Save") {
                            save()
                        }
                        .disabled(!isEditing && (consumerKey.isEmpty || consumerSecret.isEmpty || callbackURL.isEmpty || baseURL.isEmpty || instanceURL.isEmpty || communityURL.isEmpty))
                        
                    }
                }
                .frame(height: 30)
                .padding()
                .background(Color(.systemGroupedBackground)) // Set the background color
                .onAppear {
                    nameIsFocused = true
                }
                
            }
            
            NavigationView {
                
                Form {
                    
                    Section {
                        HStack {
                            Text("Name")
                                .frame(width: 80, alignment: .leading)
                            TextField("Connected App Name", text: $name)
                                .disabled(!isEditing && !isAddingNew)
                                .focused($nameIsFocused)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        if (isEditing || isAddingNew) && !name.isEmpty {
                                            Button(action: {
                                                name = ""
                                            }) {
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(.gray)
                                            }
                                            .padding(.trailing, 8)
                                        }
                                    }
                                )
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Consumer Key")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $consumerKey)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Consumer Secret")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $consumerSecret)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Callback URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $callbackURL)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Base URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $baseURL)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Instance URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $instanceURL)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Community URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $communityURL)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        
                    }
                    
                }
                .font(.system(size: 14))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                if isEditing {
                    save()
                }
                isEditing.toggle()
                }) {
                    Text(isEditing ? "Save" : "Edit")
                }
                .disabled(isEditing && (consumerKey.isEmpty || consumerSecret.isEmpty || callbackURL.isEmpty || baseURL.isEmpty || instanceURL.isEmpty || communityURL.isEmpty))
            )
        }
            
    }
    
    private func save() {
        // Handle submission of form data
        Logger.debug("Connected App Name: \(name)")
        Logger.debug("Consumer Key: \(consumerKey)")
        Logger.debug("Consumer Secret: \(consumerSecret)")
        Logger.debug("Callback URL: \(callbackURL)")
        Logger.debug("Base URL: \(baseURL)")
        Logger.debug("Instance URL: \(instanceURL)")
        Logger.debug("Community URL: \(communityURL)")
        
        let app = ForceConnectedApp(connectedAppName: name,
                                    consumerKey: consumerKey,
                                    consumerSecret: consumerSecret,
                                    callbackURL: callbackURL,
                                    baseURL: baseURL,
                                    instanceURL: instanceURL,
                                    communityURL: communityURL)
        connectedAppVM.saveApp(connectedApp: app)
        connectedAppVM.updateSavedApps()
        dismiss()
    }
    
}

//struct ConnectedAppSettingsModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectedAppSettingsView()
//    }
//}
