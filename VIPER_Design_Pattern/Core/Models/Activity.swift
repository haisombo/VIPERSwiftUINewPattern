//
//  Activity.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation
import SwiftUICore

struct Activity: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let type: ActivityType
    
    enum ActivityType: String, Sendable {
        case login = "Login"
        case profileUpdate = "Profile Update"
        case settingsChange = "Settings Change"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .login:
                return "arrow.right.circle"
            case .profileUpdate:
                return "person.circle"
            case .settingsChange:
                return "gear"
            case .other:
                return "star"
            }
        }
        
        var color: Color {
            switch self {
            case .login:
                return .blue
            case .profileUpdate:
                return .green
            case .settingsChange:
                return .orange
            case .other:
                return .gray
            }
        }
    }
}
