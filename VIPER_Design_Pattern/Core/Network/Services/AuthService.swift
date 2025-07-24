//
//  AuthService.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

protocol AuthServiceProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
    func logout() async
    func getCurrentUser() async -> User?
    var isLoggedIn: Bool { get async }
}

actor AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    
    private var currentUser: User?
    
    private init() {}
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        if email == "test@example.com" && password == "password123" {
            let user = User(
                id: "123",
                email: email,
                name: "John Doe",
                profileImageURL: nil,
                token: "mock_token_123456"
            )
            currentUser = user
            return user
        } else {
            throw NetworkError.serverError(0000)
        }
    }
    
    func logout() async {
        currentUser = nil
    }
    
    func getCurrentUser() async -> User? {
        return currentUser
    }
}
