//
//  LoginPresenter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation
import Combine
import SwiftUI


@MainActor
final class LoginPresenter: LoginPresenterProtocol {
    // Published properties for SwiftUI binding
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    // Dependencies
    private let interactor: LoginInteractorProtocol
    private let router: LoginRouterProtocol
    
    nonisolated init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func login() async {
        let validation = interactor.validateCredentials(email: email, password: password)
        
        guard validation.isValid else {
            errorMessage = validation.error ?? "Invalid credentials"
            showError = true
            return
        }
        
        isLoading = true
        
        do {
            let user = try await interactor.performLogin(email: email, password: password)
            clearFields()
            await router.navigateToHome()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    func navigateToRegister() {
        Task {
            await router.navigateToRegister()
        }
    }
    
    func navigateToForgotPassword() {
        Task {
            await router.navigateToForgotPassword()
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
    }
}
