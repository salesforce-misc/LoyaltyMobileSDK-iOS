//
//  InfoNavigationLink.swift
//  MyNTORewards
//
//  Created by Leon Qi on 4/14/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct InfoNavigationLink<Content: View, Destination: View>: View {
    var destination: Destination
    var content: Content
    var action: () -> Void
    @State private var isNavigationActive = false
    
    init(destination: Destination, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
                .foregroundColor(.primary)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle()) // Make the entire content area tappable
                .onTapGesture {
                    action()
                }
            
            Spacer()
            
            Button(action: {
                isNavigationActive = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(Color.theme.accent)
            }
            .navigationDestination(isPresented: $isNavigationActive) {
                destination
            }
        }
        
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                InfoNavigationLink(destination: InfoView(), action: {
                    Logger.debug("Tapped somewhere else")
                }) {
                    Text("Custom Navigation Link")
                }
            }
            .navigationTitle("Home")
                        
        }
    }
}

struct InfoView: View {
    var body: some View {
        Text("Info View")
            .navigationTitle("Info")
    }
}

struct InfoNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
