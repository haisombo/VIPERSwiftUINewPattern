//
//  QuickActionsSection.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct QuickActionsSection: View {
    let onProfileTap: () -> Void
    let onSettingsTap: () -> Void
    let onLogoutTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.horizontal, 4)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Profile",
                    icon: "person.fill",
                    color: .blue,
                    action: onProfileTap
                )
                
                QuickActionButton(
                    title: "Settings",
                    icon: "gear",
                    color: .gray,
                    action: onSettingsTap
                )
                
                QuickActionButton(
                    title: "Logout",
                    icon: "arrow.right.square",
                    color: .red,
                    action: onLogoutTap
                )
            }
        }
    }
}

