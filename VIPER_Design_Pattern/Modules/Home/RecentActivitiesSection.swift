//
//  RecentActivitiesSection.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct RecentActivitiesSection: View {
    
    let activities: [Activity]
    let onActivityTap: (Activity) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activities")
                .font(.headline)
                .padding(.horizontal)
            
            if activities.isEmpty {
                Text("No recent activities")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(activities) { activity in
                        ActivityRow(activity: activity)
                            .onTapGesture {
                                onActivityTap(activity)
                            }
                        
                        if activity.id != activities.last?.id {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color(.systemBackground))
            }
        }
    }
}

