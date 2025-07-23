//
//  LoginProtocols.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@preconcurrency protocol LoginViewProtocol {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func clearFields()
}

@MainActor
protocol LoginPresenterProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var isLoading: Bool { get }
    var showError: Bool { get set }
    var errorMessage: String { get }
    
    func login() async
    func navigateToRegister()
    func navigateToForgotPassword()
}

protocol LoginInteractorProtocol: Sendable {
    func performLogin(email: String, password: String) async throws -> User
    func validateCredentials(email: String, password: String) -> (isValid: Bool, error: String?)
}

protocol LoginRouterProtocol: Sendable {
    func navigateToHome() async
    func navigateToRegister() async
    func navigateToForgotPassword() async
}
