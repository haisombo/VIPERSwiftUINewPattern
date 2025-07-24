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

struct LoginResponse: Codable {
    let user: User
    let accessToken: String
    let refreshToken: String?
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int?
}
