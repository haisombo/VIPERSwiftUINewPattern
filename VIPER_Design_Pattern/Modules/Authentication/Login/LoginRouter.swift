//
//  LoginRouter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@MainActor
struct LoginRouter: LoginRouterProtocol {
    private let appRouter: AppRouter
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }
    

    func navigateToHome() async {
        appRouter.replaceStack(with: .home)
    }
    
//    @MainActor
    func navigateToRegister() async {
        print("Navigate to Register")
        appRouter.showError("Register module not implemented")
    }
    
//    @MainActor
    func navigateToForgotPassword() async {
        print("Navigate to Forgot Password")
        appRouter.showError("Forgot Password module not implemented")
    }
}
