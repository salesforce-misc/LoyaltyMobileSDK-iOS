//
//  AllBenefitsView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/13/22.
//

import SwiftUI

struct AllBenefitsView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var benefitVM: BenefitViewModel
    
    var body: some View {
        
        let memberId = rootVM.member?.enrollmentDetails.loyaltyProgramMemberId ?? ""
        
        if benefitVM.benefits.isEmpty {
            EmptyStateView(title: "You have no Benefits")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.background)
                .loytaltyNavigationTitle("My Benefits")
        }
        
        if #available(iOS 16, *) {
            List {
                VStack {
                    ForEach(benefitVM.benefits) { benefit in
                        HStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .overlay(
                                    Assets.getBenefitsLogo(for: benefit.benefitTypeName)
                                        .renderingMode(.template)
                                        .foregroundColor(Color.theme.accent)
                                )
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("\(benefit.benefitName)")
                                        .font(.benefitText)
                                        .foregroundColor(Color.theme.accent)
                                    Spacer()
                                }

                                HStack {
                                    Text("\(benefitVM.benefitDescs[benefit.id] ?? "")")
                                        .font(.benefitDescription)
                                        .lineSpacing(4)
                                        .foregroundColor(Color.theme.superLightText)
                                    Spacer()
                                }

                            }
                            
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .refreshable {
                print("Benefits refreshing...")
                do {
                    try await benefitVM.getBenefits(memberId: memberId, reload: true)
                } catch {
                    print("Reload Benefits Error: \(error)")
                }
            }
            .loytaltyNavigationTitle("My Benefits")

        } else {
            List {
                VStack {
                    ForEach(benefitVM.benefits) { benefit in
                        HStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .overlay(
                                    Assets.getBenefitsLogo(for: benefit.benefitTypeName)
                                        .renderingMode(.template)
                                        .foregroundColor(Color.theme.accent)
                                )
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("\(benefit.benefitName)")
                                        .font(.benefitText)
                                        .foregroundColor(Color.theme.accent)
                                    Spacer()
                                }

                                HStack {
                                    Text("\(benefitVM.benefitDescs[benefit.id] ?? "")")
                                        .font(.benefitDescription)
                                        .lineSpacing(4)
                                        .foregroundColor(Color.theme.superLightText)
                                    Spacer()
                                }

                            }
                            
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
            }
            .background(Color.theme.background)
            .listStyle(.plain)
            .refreshable {
                print("Benefits refreshing...")
                do {
                    try await benefitVM.getBenefits(memberId: memberId, reload: true)
                } catch {
                    print("Reload Benefits Error: \(error)")
                }
            }
            .loytaltyNavigationTitle("My Benefits")
            .onAppear(perform: {
                // set the current background color
                UITableView.appearance().backgroundColor = UIColor(Color.theme.background)
            })
            .onDisappear(perform: {
                // reset the background color to the system default
                UITableView.appearance().backgroundColor = UIColor.systemBackground
            })
        }
        
        
    }
}

struct AllBenefitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllBenefitsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.benefitVM)
    }
}
