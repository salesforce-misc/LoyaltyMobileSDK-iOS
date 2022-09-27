//
//  SignUpView.swift
//  LoyaltyStarter
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @EnvironmentObject var appViewRouter: AppViewRouter
    @Environment(\.dismiss) private var dismiss
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    
    @State var signUpProcessing = false
    @State var signUpErrorMessage = ""
    
    @State var signInPresented = false
    
    var body: some View {
        
        SheetHeader(title: "Join")

        VStack(spacing: 15) {
            SignUpCredentialFields(email: $email, password: $password, passwordConfirmation: $passwordConfirmation)
            Button(action: {
                signUpUser(userEmail: email, userPassword: password)
            }) {
                Text("Join")
            }
            .buttonStyle(DarkLongButton())
            .disabled(!signUpProcessing && !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty && password == passwordConfirmation ? false : true)
            if signUpProcessing {
                ProgressView()
            }
            if !signUpErrorMessage.isEmpty {
                Text("Failed creating account: \(signUpErrorMessage)")
                    .foregroundColor(.red)
            }
            HStack {
                Text("Already a member?")
                Button(action: {
                    signInPresented.toggle()
                }) {
                    Text("Sign In")
                        .font(.buttonText)
                }
                .sheet(isPresented: $signInPresented) {
                    SignInView()
                }
                .presentationDetents([.medium, .large])
            }
        }
        .padding()
    }
    
    func signUpUser(userEmail: String, userPassword: String) {
        
        signUpProcessing = true
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                signUpErrorMessage = error!.localizedDescription
                signUpProcessing = false
                return
            }
            
            switch authResult {
            case .none:
                print("Could not create account.")
                signUpProcessing = false
            case .some(_):
                print("User created")
                signUpProcessing = false
                appViewRouter.currentPage = .homePage
                appViewRouter.signedIn = true
                Task{
                    do {
                        try await ForceAuthManager.shared.grantAuth()
                    }catch {
                        print("failed to grantAuth")
                    }
                }
            }
        }
        
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .previewLayout(.sizeThatFits)
    }
}

struct SignUpCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
    var body: some View {
        Group {
            TextField("Email", text: $email)
                .textFieldStyle(RegularTextFieldStyle())

            RevealableSecureField("Password", text: $password)

            RevealableSecureField("Confirm Password", text: $passwordConfirmation)
                .border(Color.red, width: passwordConfirmation != password ? 1 : 0)
            
        }
    }
}

