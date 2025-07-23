//
//  HomePresenterProtocol.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@MainActor
protocol HomePresenterProtocol : ObservableObject {
    var user: User? { get }
    var isLoading: Bool { get }
    var showError: Bool { get set }
    var errorMessage: String { get }
    var recentActivities: [Activity] { get }
    
    func loadUser() async
    func refreshData() async
    func logout() async
    func navigateToProfile()
    func navigateToSettings()
    func navigateToActivity(_ activity: Activity)
}

protocol HomeInteractorProtocol: Sendable {
    func fetchUser() async throws -> User
    func fetchRecentActivities() async throws -> [Activity]
    func performLogout() async
}

protocol HomeRouterProtocol: Sendable {
    func navigateToLogin() async
    func navigateToProfile(userId: String) async
    func navigateToSettings() async
    func navigateToActivityDetail(activityId: String) async
}
