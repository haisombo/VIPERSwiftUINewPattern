//
//  SettingsRouter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct SettingsRouter: SettingsRouterProtocol {
    private let appRouter: AppRouter
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    @MainActor
    func navigateToLogin() async {
        appRouter.replaceStack(with: .login)
    }
    
    @MainActor
    func navigateToAbout() async {
        print("Navigate to About")
        appRouter.showError("About page not implemented")
    }
    
    @MainActor
    func navigateToPrivacy() async {
        print("Navigate to Privacy Policy")
        appRouter.showError("Privacy Policy not implemented")
    }
    
    @MainActor
    func navigateToTerms() async {
        print("Navigate to Terms of Service")
        appRouter.showError("Terms of Service not implemented")
    }
}
