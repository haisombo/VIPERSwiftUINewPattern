//
//  HomeInteractor.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

struct HomeInteractor: HomeInteractorProtocol {
    private let authService: AuthServiceProtocol
    private let userDefaultsManager: UserDefaultsManager
    
    init(
        authService: AuthServiceProtocol = AuthService.shared,
        userDefaultsManager: UserDefaultsManager = .shared
    ) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func fetchUser() async throws -> User {
        // Try to get from auth service first
        if let user = await authService.getCurrentUser() {
            return user
        }
        
        // Fallback to stored data
        let userId = await userDefaultsManager.userId ?? "123"
        let email = await userDefaultsManager.userEmail ?? "user@example.com"
        let name = await userDefaultsManager.userName ?? "User"
        
        return User(
            id: userId,
            email: email,
            name: name,
            profileImageURL: nil,
            token: nil
        )
    }
    
    func fetchRecentActivities() async throws -> [Activity] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Return mock activities
        return [
            Activity(
                id: "1",
                title: "Logged In",
                description: "Successfully logged into your account",
                date: Date().addingTimeInterval(-3600),
                type: .login
            ),
            Activity(
                id: "2",
                title: "Profile Updated",
                description: "Changed profile picture",
                date: Date().addingTimeInterval(-7200),
                type: .profileUpdate
            ),
            Activity(
                id: "3",
                title: "Settings Changed",
                description: "Enabled dark mode",
                date: Date().addingTimeInterval(-10800),
                type: .settingsChange
            )
        ]
    }
    
    func performLogout() async {
        await authService.logout()
        await userDefaultsManager.clearAll()
    }
}
