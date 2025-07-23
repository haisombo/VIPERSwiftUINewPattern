//
//  LoginInteractor.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

struct LoginInteractor: LoginInteractorProtocol {
    private let authService: AuthServiceProtocol
    private let userDefaultsManager: UserDefaultsManager
    
    init(
        authService: AuthServiceProtocol = AuthService.shared,
        userDefaultsManager: UserDefaultsManager = .shared
    ) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func performLogin(email: String, password: String) async throws -> User {
        let user = try await authService.login(email: email, password: password)
        
        // Save user data
        await userDefaultsManager.setLoggedIn(true)
        await userDefaultsManager.setUserEmail(user.email)
        await userDefaultsManager.setUserName(user.name)
        await userDefaultsManager.setUserId(user.id)
        
        return user
    }
    
    func validateCredentials(email: String, password: String) -> (isValid: Bool, error: String?) {
        if email.isEmpty {
            return (false, "Please enter your email")
        }
        
        if !email.contains("@") || !email.contains(".") {
            return (false, "Please enter a valid email")
        }
        
        if password.isEmpty {
            return (false, "Please enter your password")
        }
        
        if password.count < 6 {
            return (false, "Password must be at least 6 characters")
        }
        
        return (true, nil)
    }
}
