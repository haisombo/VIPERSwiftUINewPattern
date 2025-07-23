//
//  AppRouter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

enum AppRoute: Hashable, Sendable {
    case login
    case home
    case profile(userId: String)
    case settings
}

@MainActor
final class AppRouter: ObservableObject {
    
    @Published var path             = NavigationPath()
    @Published var presentedSheet   : AppRoute?
    @Published var showError        = false
    @Published var errorMessage     = ""
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    func replaceStack(with route: AppRoute) {
        path.removeLast(path.count)
        path.append(route)
    }
    
    func presentSheet(_ route: AppRoute) {
        presentedSheet = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
}

