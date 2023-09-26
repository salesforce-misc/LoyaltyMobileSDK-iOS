//
//  HomeView.swift
//  MyNTORewards
//
//  Created by Frank Wang on 8/24/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct HomeView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @EnvironmentObject private var promotionVM: PromotionViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
	@EnvironmentObject private var cameraVM: CameraViewModel
	@EnvironmentObject private var routerPath: RouterPath
	@EnvironmentObject private var receiptListViewModel: ReceiptListViewModel
	@State var showCapturedImage: Bool = false
	@State var capturedImage: UIImage?
    @Binding var selectedTab: Int
    
	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				VStack(spacing: 0) {
					HStack {
						Image("ic-logo-home")
							.padding(.leading, 15)
						Spacer()
						Image("ic-receipts-home")
							.padding(.trailing, 15)
							.accessibilityIdentifier(AppAccessibilty.Receipts.receiptsIcon)
							.onTapGesture {
								routerPath.dismissSheets()
								cameraVM.showCamera = true
							}
					}
					.frame(height: 44)
					.frame(maxWidth: .infinity)
					.background(Color.theme.accent)
				}
				
				ScrollView(showsIndicators: false) {
					HStack {
						Text("Hello \(rootVM.member?.firstName.capitalized ?? ""),")
							.padding(.leading, 15)
							.accessibilityIdentifier(AppAccessibilty.Home.userName)
						Spacer()
						// swiftlint:disable line_length
						Text("\(String(profileVM.profile?.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName) ?? 0)) \(AppSettings.Defaults.rewardCurrencyName)")
							.padding(.trailing, 15)
							.accessibilityIdentifier(AppAccessibilty.Home.rewardPoints)
						// swiftlint:enable line_length
					}
					.frame(height: 48)
					.frame(maxWidth: .infinity)
					.background(Color.theme.backgroundPink)
					.background(
						Rectangle()
							.fill(Color.white)
							.shadow(
								color: Color.gray.opacity(0.4),
								radius: 5,
								x: 0,
								y: 0
							)
					)
					
					// Offers & Promotions
					PromotionCarouselView(selectedTab: $selectedTab)
						.frame(height: 400)
						.padding(.top, 40)
						.padding(.bottom, 40)
					
					/* Post MVP
					 // Redeem Points
					 RedeemPointsView()
					 */
					
					VouchersView()
						.padding(.bottom, 100)
					
				}
				.background(Color.theme.background)
				.task {
					do {
						try await profileVM.getProfileData(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
					} catch {
						Logger.error("Fetch profile Error: \(error)")
					}
				}
				.refreshable {
					Logger.debug("Reloading home...")
					Task {
						do {
							try await profileVM.fetchProfile(memberId: rootVM.member?.loyaltyProgramMemberId ?? "")
						} catch {
							Logger.error("Reload Profile Error: \(error)")
						}
					}
					
					Task {
						do {
							try await promotionVM.fetchCarouselPromotions(membershipNumber: rootVM.member?.membershipNumber ?? "")
						} catch {
							Logger.error("Reload Promotions Error: \(error)")
						}
					}
					
					Task {
						do {
							try await voucherVM.loadVouchers(membershipNumber: rootVM.member?.membershipNumber ?? "", reload: true)
						} catch {
							Logger.error("Reload Vouchers Error: \(error)")
						}
					}
				}
				.navigationBarHidden(true)
			}
			.withSheetDestination(sheetDestination: $routerPath.presentedSheet)
		}
		.fullScreenCover(isPresented: $cameraVM.showCamera) {
			ZStack {
				ZStack {
					CameraView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
						.zIndex(showCapturedImage ? 0 : 1)
					
					if showCapturedImage {
						CapturedImageView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
							.environmentObject(receiptListViewModel)
							.transition(.move(edge: .trailing))
							.zIndex(showCapturedImage ? 1 : 0)
					}
				}
				.animation(.default, value: showCapturedImage)
				.environmentObject(routerPath)
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(Tab.home.rawValue))
            .environmentObject(dev.rootVM)
            .environmentObject(dev.profileVM)
            .environmentObject(dev.promotionVM)
            .environmentObject(dev.voucherVM)
            .environmentObject(dev.imageVM)
            .environmentObject(dev.routerPath)
            .environmentObject(dev.camVM)
    }
}
