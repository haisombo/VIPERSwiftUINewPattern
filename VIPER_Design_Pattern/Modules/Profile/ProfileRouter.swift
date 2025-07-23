//
//  ProfileRouter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct ProfileRouter: ProfileRouterProtocol {
    private let appRouter: AppRouter
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    
    @MainActor
    func navigateBack() async {
        appRouter.navigateBack()
    }
    
    @MainActor
    func navigateToEditProfile(userId: String) async {
        // In a real app, navigate to edit profile
        print("Navigate to Edit Profile for user: \(userId)")
        appRouter.showError("Edit Profile not implemented")
    }
}
