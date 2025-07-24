//
//  ProductPresenterProtocol.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@MainActor
protocol ProductPresenterProtocol: ObservableObject {
    var notificationsEnabled: Bool { get set }
    var darkModeEnabled: Bool { get set }
    var biometricEnabled: Bool { get set }
    var appVersion: String { get }
    
    func logout() async
    func navigateToAbout()
    func navigateToPrivacy()
    func navigateToTerms()
}

protocol ProductInteractorProtocol : Sendable {
    func loadSettings() async -> SettingsModel
    func saveSettings(_ settings: SettingsModel) async
    func performLogout() async
}

protocol ProductRouterProtocol: Sendable {
    func navigateToLogin() async
    func navigateToAbout() async
    func navigateToPrivacy() async
    func navigateToTerms() async
}
