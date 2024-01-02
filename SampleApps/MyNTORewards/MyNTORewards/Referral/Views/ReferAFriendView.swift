//
//  ReferAFriendView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/24/23.
//

import SwiftUI
import UIKit

struct ReferAFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) var openURL
    
    @State var email: String = ""
    @State private var showCodeCopiedAlert = false
    @State private var showShareSheet: Bool = false
    
    let referralCode = "84KFF7GHSLJKL81"
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image("img-join")
                    .resizable()
                    .scaledToFill()
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
            
            VStack(alignment: .leading, spacing: 20) {
                Text("**Refer a Friend and Earn**")
                    .font(.referModalText)
                    .accessibilityIdentifier(AppAccessibilty.Referrals.referAFriendTitle)
                Text("Invite your friends and get a voucher when they shop for the first time.")
                    .font(.referModalText)
                
                ZStack(alignment: .trailing) {
                    TextField("Friend's Email Address", text: $email)
                        .textFieldStyle(RegularTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .accessibilityIdentifier(AppAccessibilty.Referrals.email)
                        .frame(height: 58)
                    
                    Button(action: {
                        // TODO: Send email
                    }) {
                        Image("ic-forward")
                            .frame(width: 40, height: 40)
                    }
                    .padding(.trailing, 20)
                }
                
                Text("Separate emails with commas.")
                    .font(.referralInfoDesc)
                    .foregroundColor(Color.theme.textInactive)
                    .padding(.leading, 30)
                    .padding(.top, -10)
            }
            .padding()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("**Or Share Via**")
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
                        ActivityViewController(activityItems: ["Check out my referral code: \(referralCode)"])
                    }
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image("ic-ig")
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ActivityViewController(activityItems: ["Check out my referral code: \(referralCode)"])
                    }
                    Button {
                        shareToWhatsApp()
                    } label: {
                        Image("ic-whatsapp")
                    }
                    Button {
                        shareToTwitter()
                    } label: {
                        Image("ic-twitter")
                    }
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image("ic-share")
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ActivityViewController(activityItems: ["Check out my referral code: \(referralCode)"])
                    }
                }
                
                HStack {
                    Text(referralCode)
                        .accessibilityIdentifier(AppAccessibilty.Referrals.referralCode)
                        .font(.referralCode)
                        .foregroundColor(Color.theme.referralCodeColor)
                        .padding(.leading, 8)
                    Spacer()
                    Text("TAP TO COPY")
                        .font(.referralTapText)
                        .foregroundColor(Color.theme.referralCodeCopy)
                        .padding(.trailing, 8)
                }
                .frame(width: 360, height: 40)
                .background(Color.theme.referralCodeBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2.0]))
                        .foregroundColor(Color.theme.referralCodeBorder)
                )
                .padding(.top, 6)
                .onTapGesture {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = referralCode
                    showCodeCopiedAlert = true
                }
                .alert(isPresented: $showCodeCopiedAlert) {
                    Alert(title: Text(AppSettings.Vouchers.codeSuccessfullyCopied))
                }
                HStack {
                    Text("Share the referral code above in any other way.")
                        .font(.referralInfoDesc)
                        .foregroundColor(Color.theme.textInactive)
                        .padding(.leading, 30)
                        .padding(.top, -10)
                    Spacer()
                }
                
                Spacer()
                
                Button("Done") {
                    
                }
                .buttonStyle(DarkLongButton())
                
                Spacer()
            }
            .padding()

        }
        .ignoresSafeArea()
        
    }

    func shareToWhatsApp() {
        let urlString = "whatsapp://send?text=Check out my referral code: \(referralCode)"
        if let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStringEncoded) {
            openURL(url)
        }
    }

    func shareToTwitter() {
        let urlString = "https://twitter.com/intent/tweet?text=Check out my referral code: \(referralCode)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    ReferAFriendView()
}
