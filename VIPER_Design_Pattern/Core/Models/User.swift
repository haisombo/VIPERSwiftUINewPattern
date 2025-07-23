//
//  User.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//


import Foundation

struct User: Codable, Identifiable, Sendable {
    let id: String
    let email: String
    let name: String
    let profileImageURL: String?
    let token: String?
}

