//
//  SignInView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var appViewRouter: AppViewRouter
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: SignInViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @Binding var signUpPresented: Bool
    
    init(appViewRouter: AppViewRouter, signUpPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: SignInViewModel(appViewRouter: appViewRouter))
        self._signUpPresented = signUpPresented
    }
    
    var body: some View {
        
        VStack {
            SheetHeader(title: "Sign In")
            VStack(spacing: 15) {
                SignInCredentialFields(email: $email, password: $password)
                Button(action: {
                    viewModel.signInUser(userEmail: email, userPassword: password)
                }) {
                    Text("Sign In")
                }
                .buttonStyle(DarkLongButton())
                .disabled(disableForm)
                .opacity(disableForm ? 0.5 : 1)
                
                if viewModel.signInProcessing {
                    ProgressView()
                }
                
                if !viewModel.signInErrorMessage.isEmpty {
                    Text("Failed creating account: \(viewModel.signInErrorMessage)")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("Not a member?")
                    Button(action: {
                        dismiss()
                        signUpPresented = true
                        appViewRouter.currentPage = .onboardingPage
                    }) {
                        Text("Join Now")
                            .font(.buttonText)
                    }
                    //.presentationDetents([.height(405)])
                }
            }
            .padding()
            Spacer()
        }
        
    }
    
    var disableForm: Bool {
        if email.isEmpty ||
            password.isEmpty ||
            viewModel.signInProcessing {
            return true
        }
        return false
    }
}

struct SignInView_Previews: PreviewProvider {
    static var appViewRouter = AppViewRouter()
    static var previews: some View {
        SignInView(appViewRouter: appViewRouter, signUpPresented: .constant(false))
            .environmentObject(appViewRouter)
            .previewLayout(.sizeThatFits)
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group {
            TextField("Email", text: $email)
                .textFieldStyle(RegularTextFieldStyle())
                .keyboardType(.emailAddress)
            RevealableSecureField("Password", text: $password)
        }
    }
}

