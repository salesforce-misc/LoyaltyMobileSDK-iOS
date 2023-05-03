//
//  RewardPointsCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/11/22.
//

import SwiftUI
import UIKit
import LoyaltyMobileSDK

struct RewardPointsCardView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    
    @State var showQRCode: Bool = false
    
    var body: some View {
        
        ZStack {
            let imageData = LoyaltyUtilities.generateQRCode(from: profileVM.profile?.membershipNumber ?? "",
                                                            color: UIColor(Color.theme.accent)) ?? Data.init()
            let coloredImage = UIImage(data: imageData) ?? UIImage(systemName: "xmark.octagon") ?? UIImage()
            
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 220)
                    .padding(.horizontal)
                    .foregroundColor(Color.theme.accent)
                    .overlay(
                        ellipseView
                            .offset(x: 260, y: -85)
                    )
                    .overlay(
                        ellipseView
                            .offset(x: 190, y: 120)
                    )
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        Image("ic-logo-card")
                            .padding(.top, 20)
                            .padding(.trailing, 35)
                    }
                    .overlay(alignment: .topLeading) {
                        let tierName = profileVM.profile?.memberTiers[0].loyaltyMemberTierName ?? ""
                        Text(tierName)
                            .accessibilityIdentifier(AppAccessibilty.Profile.tierName)
                            .font(.transactionPoints)
                            .padding()
                            .frame(height: 26)
                            .frame(minWidth: 72, maxWidth: max(72, tierName.stringWidth()+30))
                            .background(Assets.getTierColor(tierName: tierName))
                            .cornerRadius(30)
                            .padding(.top, 15)
                            .padding(.leading, 35)

                    }
                    .overlay(alignment: .bottomLeading) {
                        Text("REWARD POINTS") // Hardcoded for now
                            .accessibilityIdentifier(AppAccessibilty.Profile.rewardPointsText)
                            .font(.transactionPoints)
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                            .padding(.bottom, 15)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        
                        Button {
                            showQRCode.toggle()
                        } label: {
                            Image(uiImage: coloredImage)
                                .resizable()
                                .frame(width: 46, height: 46)
                                .cornerRadius(4)
                                .padding(.trailing, 35)
                                .padding(.bottom, 15)
                        }
                        .accessibilityIdentifier(AppAccessibilty.Profile.qrCode)
                        .sheet(isPresented: $showQRCode) {
                            let name = "\(rootVM.member?.firstName ?? "") \(rootVM.member?.lastName ?? "")"
                            let number = rootVM.member?.membershipNumber ?? ""
                            QRCodeView(QRCodeImage: coloredImage,
                                       name: name,
                                       membershipNumber: number)
                        }
                    }
                    .overlay(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(String(profileVM.profile?.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName) ?? 0))
                                .font(.cardPointsText)
                                .accessibilityIdentifier(AppAccessibilty.Profile.rewardPoints)
                            
                            // Incorrect, a new API will be provided
//                            if let expiringDate = profileVM.profile?.memberTiers[0].tierExpirationDate,
//                               let expiringPoints = profileVM.profile?.getCurrencyPoints(currencyName: AppConstants.Config.tierCurrencyName) {
//                                Text("\(expiringPoints) points expiring on \(expiringDate)")
//                                    .font(.cardExpiringPointsText)
//                            }
                            
                        }
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                        
                    }
                
                /* After MVP item. Hide tier points progressbar for now.
                    VStack(spacing: 0) {
                        GeometryReader { geo in
                            ZStack(alignment: .topLeading) {
                                Capsule()
                                    .fill(Color.theme.progressBarBackground)
                                Capsule()
                                    .fill(Color.theme.accent)
                                    .frame(maxWidth: CGFloat(Float(currentTierPoints) / Float(currentTierLimit)) * (geo.size.width))
                            }
                            .frame(height: 6)
                        }
                        .frame(height: 6)
                        
                        HStack {
                            Text("\(Text(String(currentTierPoints)).foregroundColor(Color.theme.accent))/\(String(currentTierLimit))")
                                .foregroundColor(Color.theme.tierPoints)
                                .font(.tierPointsText)
                            Spacer()
                            Text("Tier Expiring on Dec 31")
                                .font(.tierPointsNotes)
                        }
                        .padding(.vertical)
                    }
                    .padding()
                 */
                
            }
            .task {
                do {
                    try await profileVM.getProfileData(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
                } catch {
                    Logger.error("Fetch profile Error: \(error)")
                }
            }
            
            if profileVM.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        
    }
    
    var ellipseView: some View {
        Ellipse()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.93, green: 0.88, blue: 0.98),
                                                             Color(red: 0.93, green: 0.88, blue: 0.98)]),
                                 startPoint: .top,
                                 endPoint: .bottom))
            .opacity(0.10)
            .frame(width: 421.27, height: 359.37)
    }
    
    func setImageColor(image: UIImage, color: UIColor) -> UIImage {
        var newImage = image
        newImage = newImage.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: newImage)
        imageView.tintColor = color
        return imageView.image ?? image
    }
}

struct RewardPointsCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardPointsCardView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
            .previewLayout(.sizeThatFits)
    }
}
