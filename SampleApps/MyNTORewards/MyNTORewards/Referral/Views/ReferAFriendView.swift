//
//  ReferAFriendView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/24/23.
//

import SwiftUI
import UIKit
import ReferralMobileSDK

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
    let promotion: ReferralPromotionObject?
    
    var body: some View {
        let referralLink = "\(promotion?.promotionPageUrl ?? "")?referralCode=\(referralVM.referralCode)-\(promotionCode)"
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
            }.onDisappear(perform: {
                referralVM.displayError = (false, "")
            })
        } else {
            ZStack {
                VStack {
                    GeometryReader { geometry in
                        Group {
                            if promotion?.promotionImageUrl != nil {
                                LoyaltyAsyncImage(url: promotion?.promotionImageUrl, content: { image in
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
                            Text("**\(promotion?.name ?? "")**")
                                .font(.referModalNameText)
                                .padding(.top, 10)
                                .padding(.horizontal, 15)
                                .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                            if let description = promotion?.description {
                                Text(description)
                                    .lineSpacing(5)
                                    .font(.referModalText)
                                    .foregroundStyle(Color.theme.superLightText)
                                    .padding(.horizontal, 15)
                            }
                            
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
                                                try await referralVM.sendReferral(email: email, promoCode: promotionCode)
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
                                        .foregroundStyle(Color.theme.accent)
                                }
                                .padding(.trailing, 20)
                                .disabled(processing || email.isEmpty)
                                .opacity(processing || email.isEmpty ? 0.5 : 1)
                                .alert(isPresented: $showEmailSentAlert) {
                                    Alert(title: Text(StringConstants.Referrals.emailSentAlertTitle),
                                          message: Text(StringConstants.Referrals.emailSentAlertText))
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
                            
                            HStack {
                                Spacer()
                                Text("**\(StringConstants.Referrals.shareText)**")
                                    .font(.referModalText)
                                Spacer()
                            }
                            
                            HStack(spacing: 15) {
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
                            }.frame(maxWidth: .infinity)

                            HStack(spacing: 8) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(promotion?.promotionPageUrl ?? "")?referralCode=")
                                        .accessibilityIdentifier(AppAccessibilty.Referrals.referralCode)
                                        .font(.referralShareLinkText)
                                        .foregroundColor(Color.theme.referralShareLinkColor)
                                    Text("\(referralVM.referralCode)-\(promotionCode)")
                                        .accessibilityIdentifier(AppAccessibilty.Referrals.referralCode)
                                        .font(.referralCode)
                                        .foregroundColor(Color.theme.accent)
                                }.padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.theme.textFieldBackground)
                                    .cornerRadius(10)
                                
                                Button {
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string = referralLink
                                    showCodeCopiedAlert = true
                                } label: {
                                    Image("ic-copyLink")
                                }
                            } .padding(.horizontal, 15)
                                .padding(.top, 16)
                                .alert(isPresented: $showCodeCopiedAlert) {
                                    Alert(title: Text(StringConstants.Referrals.copiedText))
                                }
                            
                            Button(StringConstants.Referrals.doneButton) {
                                dismiss()
                            }
                            .buttonStyle(DarkLongButton())
                            .padding(.top, 40)
                            Spacer()
                        }.frame(maxWidth: .infinity)
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
