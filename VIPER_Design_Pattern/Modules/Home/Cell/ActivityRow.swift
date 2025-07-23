//
//  ActivityRow.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.type.icon)
                .font(.title3)
                .foregroundColor(activity.type.color)
                .frame(width: 40, height: 40)
                .background(activity.type.color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(activity.date, style: .relative)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
    }
}
