//
//  SettingsPresenter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

@MainActor
final class SettingsPresenter : SettingsPresenterProtocol {
    @Published var notificationsEnabled = false {
        didSet { saveSettings() }
    }
    @Published var darkModeEnabled = false {
        didSet { saveSettings() }
    }
    @Published var biometricEnabled = false {
        didSet { saveSettings() }
    }
    
    let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    private let interactor: SettingsInteractorProtocol
    private let router: SettingsRouterProtocol
    
    nonisolated init(
        interactor: SettingsInteractorProtocol,
        router: SettingsRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadSettings() async {
        let settings = await interactor.loadSettings()
        notificationsEnabled = settings.notificationsEnabled
        darkModeEnabled = settings.darkModeEnabled
        biometricEnabled = settings.biometricEnabled
    }
    
    private func saveSettings() {
        let settings = SettingsModel(
            notificationsEnabled: notificationsEnabled,
            darkModeEnabled: darkModeEnabled,
            biometricEnabled: biometricEnabled
        )
        
        Task {
            await interactor.saveSettings(settings)
        }
    }
    
    func logout() async {
        await interactor.performLogout()
        await router.navigateToLogin()
    }
    
    func navigateToAbout() {
        Task {
            await router.navigateToAbout()
        }
    }
    
    func navigateToPrivacy() {
        Task {
            await router.navigateToPrivacy()
        }
    }
    
    func navigateToTerms() {
        Task {
            await router.navigateToTerms()
        }
    }
}
