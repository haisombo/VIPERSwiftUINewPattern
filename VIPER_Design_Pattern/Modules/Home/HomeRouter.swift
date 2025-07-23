//
//  HomeRouter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct HomeRouter: HomeRouterProtocol {
    private let appRouter: AppRouter
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    @MainActor
    func navigateToLogin() async {
        appRouter.replaceStack(with: .login)
    }
    
    @MainActor
    func navigateToProfile(userId: String) async {
        appRouter.navigate(to: .profile(userId: userId))
    }
    
    @MainActor
    func navigateToSettings() async {
        appRouter.navigate(to: .settings)
    }
    
    @MainActor
    func navigateToActivityDetail(activityId: String) async {
        // In a real app, you would navigate to activity detail
        print("Navigate to Activity Detail: \(activityId)")
        appRouter.showError("Activity detail not implemented")
    }
}
