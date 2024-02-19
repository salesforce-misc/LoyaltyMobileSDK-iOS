//
//  ReferAFriendView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/24/23.
//

import SwiftUI
import UIKit
import ReferralMobileSDK
import LoyaltyMobileSDK

struct ReferAFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var referralVM: ReferralViewModel
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var showCodeCopiedAlert = false
    @State private var showEmailSentAlert = false
    @State private var showShareSheet: Bool = false
    @State private var processing: Bool = false
    @State private var validationMessage = ""
    let promotionCode: String
    let promotion: PromotionResult?
    
    var body: some View {
        let referralLink = "\(AppSettings.Defaults.referralLink)\(referralVM.referralCode)-\(promotionCode)"
        let shareText = "\(StringConstants.Referrals.shareReferralText) \(referralLink)"
        if referralVM.displayError.0 {
            ZStack {
                Color.theme.background
                VStack {
                    Spacer()
                    ProcessingErrorView(message: referralVM.displayError.1)
                    Spacer()
                    Button {
                        referralVM.displayError = (false, "")
                        dismiss()
                    } label: {
                        Text(StringConstants.Referrals.backButton)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .longFlexibleButtonStyle()
                    .accessibilityIdentifier(AppAccessibilty.Referrals.joinErrorBackButton)
                }
            }
        } else {
            ZStack {
                VStack {
                    GeometryReader { geometry in
                        Group {
                            if promotion?.promotionImageURL != nil {
                                LoyaltyAsyncImage(url: promotion?.promotionImageURL, content: { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                }, placeholder: {
                                    ProgressView()
                                })
                            } else {
                                Image("img-join")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(maxWidth: geometry.size.width, maxHeight: 160)
                        .clipped()
                        .overlay(alignment: .topTrailing) {
                            Image("ic-dismiss")
                                .accessibilityIdentifier(AppAccessibilty.Promotion.dismissButton)
                                .padding()
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    }
                    .frame(maxHeight: 160)
                    
                    ScrollView {

                    VStack(alignment: .leading, spacing: 20) {
                        Text("**\(promotion?.promotionName ?? "")**")
                            .font(.referModalNameText)
                            .padding(.top, 10)
                            .padding(.horizontal, 15)
                            .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                        Text(promotion?.description ?? "")
                            .lineSpacing(5)
                            .font(.referModalText)
                            .foregroundStyle(Color.theme.superLightText)
                            .padding(.horizontal, 15)
                        
                        ZStack(alignment: .trailing) {
                            TextField(StringConstants.Referrals.referEmailText, text: $email)
                                .textFieldStyle(RegularTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .accessibilityIdentifier(AppAccessibilty.Referrals.email)
                                .frame(height: 58)
                            
                            Button(action: {
                                validationMessage = ""
                                self.isEmailValid = validateEmailInput(input: email)
                                if isEmailValid {
                                    processing = true
                                    Task {
                                        do {
                                            try await referralVM.sendReferral(email: email)
                                            if !referralVM.displayError.0 {
                                                showEmailSentAlert = true
                                                do {
                                                    try await referralVM.loadAllReferrals(memberContactId: rootVM.member?.contactId ?? "", reload: true)
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                        processing = false
                                        email = ""
                                    }
                                    
                                } else {
                                    validationMessage = StringConstants.Referrals.emailValidationError
                                }
                            }) {
                                Image("ic-forward")
                                    .frame(width: 40, height: 40)
                            }
                            .padding(.trailing, 20)
                            .disabled(processing || email.isEmpty)
                            .opacity(processing || email.isEmpty ? 0.5 : 1)
                            .alert(isPresented: $showEmailSentAlert) {
                                Alert(title: Text(StringConstants.Referrals.emailSentAlertTitle), message: Text(StringConstants.Referrals.emailSentAlertText))
                            }
                        }
                        
                        Text(StringConstants.Referrals.commaText)
                            .font(.referralInfoDesc)
                            .foregroundColor(Color.theme.textInactive)
                            .padding(.leading, 30)
                            .padding(.top, -10)
                        
                        HStack {
                            Spacer()
                            Text(validationMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .opacity(validationMessage.isEmpty ? 0 : 1)
                        .frame(height: 40)
                        
                    }
                    
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Text("**\(StringConstants.Referrals.shareText)**")
                                .font(.referModalText)
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            Button {
                                showShareSheet.toggle()
                            } label: {
                                Image("ic-fb")
                            }
                            .sheet(isPresented: $showShareSheet) {
                                ActivityViewController(activityItems: [shareText])
                            }
                            Button {
                                showShareSheet.toggle()
                            } label: {
                                Image("ic-ig")
                            }
                            .sheet(isPresented: $showShareSheet) {
                                ActivityViewController(activityItems: [shareText])
                            }
                            Button {
                                shareToWhatsApp(text: shareText)
                            } label: {
                                Image("ic-whatsapp")
                            }
                            Button {
                                shareToTwitter(text: shareText)
                            } label: {
                                Image("ic-twitter")
                            }
                            Button {
                                showShareSheet.toggle()
                            } label: {
                                Image("ic-share")
                            }
                            .sheet(isPresented: $showShareSheet) {
                                ActivityViewController(activityItems: [shareText])
                            }
                        }
                        
                        HStack {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(referralLink)
                                        .accessibilityIdentifier(AppAccessibilty.Referrals.referralCode)
                                        .font(.referralCode)
                                        .foregroundColor(Color.theme.referralCodeColor)
                                        .padding(.leading, 8)
                                    Spacer()
                                }
                            }
                            .frame(width: 300, height: 40)
                            Spacer()
                            Divider()
                                .background(Color.theme.referralLinkDivider)
                            Text(StringConstants.Referrals.copyText.uppercased())
                                .font(.referralTapText)
                                .foregroundColor(Color.theme.referralCodeCopy)
                                .padding(.trailing, 8)
                        }
                        .frame(height: 40)
                        .background(Color.theme.referralCodeBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2.0]))
                                .foregroundColor(Color.theme.referralCodeBorder)
                        )
                        .padding(.horizontal, 15)
                        .padding(.top, 6)
                        .onTapGesture {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = referralLink
                            showCodeCopiedAlert = true
                        }
                        .alert(isPresented: $showCodeCopiedAlert) {
                            Alert(title: Text(StringConstants.Referrals.copiedText))
                        }
                        
                        Button(StringConstants.Referrals.doneButton) {
                            dismiss()
                        }
                        .buttonStyle(DarkLongButton())
                        Spacer()
                        
                    }
                }
            }
                if processing {
                    ProgressView()
                }

            }
            .ignoresSafeArea()
            .task {
                await referralVM.loadReferralCode(membershipNumber: rootVM.member?.membershipNumber ?? "", promoCode: promotionCode)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateEmailInput(input: String) -> Bool {
        let emails = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return emails.allSatisfy(isValidEmail)
    }
    
    func shareToWhatsApp(text: String) {
        let urlString = "whatsapp://send?text=\(text)"
        if let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStringEncoded) {
            openURL(url)
        }
    }
    
    func shareToTwitter(text: String) {
        let urlString = "https://twitter.com/intent/tweet?text=\(text)"
        if let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStringEncoded) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    ReferAFriendView(promotionCode: "", promotion: nil)
        .environmentObject(AppRootViewModel())
        .environmentObject(ReferralViewModel())
}
