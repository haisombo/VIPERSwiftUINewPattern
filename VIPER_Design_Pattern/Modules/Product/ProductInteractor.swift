//
//  ProductInteractor.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

struct ProductInteractor: ProductInteractorProtocol {
    private let authService: AuthServiceProtocol
    private let userDefaultsManager: UserDefaultsManager
    
    init(
        authService: AuthServiceProtocol = AuthService.shared,
        userDefaultsManager: UserDefaultsManager = .shared
    ) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func loadSettings() async -> SettingsModel {
        // Load from UserDefaults or other storage
        SettingsModel(
            notificationsEnabled: UserDefaults.standard.bool(forKey: "notificationsEnabled"),
            darkModeEnabled: UserDefaults.standard.bool(forKey: "darkModeEnabled"),
            biometricEnabled: UserDefaults.standard.bool(forKey: "biometricEnabled")
        )
    }
    
    func saveSettings(_ settings: SettingsModel) async {
        UserDefaults.standard.set(settings.notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(settings.darkModeEnabled, forKey: "darkModeEnabled")
        UserDefaults.standard.set(settings.biometricEnabled, forKey: "biometricEnabled")
    }
    
    func performLogout() async {
        await authService.logout()
        await userDefaultsManager.clearAll()
    }
}
