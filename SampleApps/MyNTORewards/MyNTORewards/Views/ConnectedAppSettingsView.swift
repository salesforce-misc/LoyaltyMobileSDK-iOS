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
    @EnvironmentObject private var connectedAppVM: ConnectedAppsViewModel<ForceConnectedAppKeychainManager>
    
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
    @State var selfRegisterURL: String
    
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
                        .disabled(!isEditing &&
                                  (consumerKey.isEmpty ||
                                   consumerSecret.isEmpty ||
                                   callbackURL.isEmpty ||
                                   baseURL.isEmpty ||
                                   instanceURL.isEmpty ||
                                   communityURL.isEmpty ||
                                   selfRegisterURL.isEmpty))
                        
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
                                .foregroundColor(.secondary)
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
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Consumer Secret")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $consumerSecret)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Callback URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $callbackURL)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Base URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $baseURL)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Instance URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $instanceURL)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Community URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $communityURL)
                                .foregroundColor(.secondary)
                                .frame(height: 60)
                                .disabled(!isEditing && !isAddingNew)
                        }
                        HStack {
                            Text("Self Register URL")
                                .frame(width: 80, alignment: .leading)
                            TextEditor(text: $selfRegisterURL)
                                .foregroundColor(.secondary)
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
                .disabled(isEditing &&
                          (consumerKey.isEmpty ||
                           consumerSecret.isEmpty ||
                           callbackURL.isEmpty ||
                           baseURL.isEmpty ||
                           instanceURL.isEmpty ||
                           communityURL.isEmpty ||
                           selfRegisterURL.isEmpty))
            )
        }
            
    }
    
    private func save() {
        
        let app = ForceConnectedApp(connectedAppName: name,
                                    consumerKey: consumerKey,
                                    consumerSecret: consumerSecret,
                                    callbackURL: callbackURL,
                                    baseURL: baseURL,
                                    instanceURL: instanceURL,
                                    communityURL: communityURL,
                                    selfRegisterURL: selfRegisterURL)
        connectedAppVM.saveApp(connectedApp: app)
        connectedAppVM.updateSavedApps()
        dismiss()
    }
    
}

 struct ConnectedAppSettingsModalView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedAppSettingsView(name: "Sample",
                                 consumerKey: "key123",
                                 consumerSecret: "secret123",
                                 callbackURL: "https://abc.com/callback",
                                 baseURL: "https://abc.com",
                                 instanceURL: "https://abc.com/instance",
                                 communityURL: "https://abc.com/community",
                                 selfRegisterURL: "https://abc.com/self-register")
    }
 }
