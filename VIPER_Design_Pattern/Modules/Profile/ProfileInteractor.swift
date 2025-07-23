//
//  ProfileInteractor.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

struct ProfileInteractor: ProfileInteractorProtocol {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    func fetchUserProfile(userId: String) async throws -> User {
        // In a real app, fetch from network
        // For now, return mock data or current user
        if let currentUser = await authService.getCurrentUser() {
            return currentUser
        }
        
        // Mock data
        return User(
            id: userId,
            email: "user@example.com",
            name: "John Doe",
            profileImageURL: nil,
            token: nil
        )
    }
}
