//
//  HomePresenter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

import Foundation

@MainActor
final class HomePresenter: HomePresenterProtocol {
    @Published var user: User?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var recentActivities: [Activity] = []
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    nonisolated init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadUser() async {
        isLoading = true
        
        do {
            async let userTask = interactor.fetchUser()
            async let activitiesTask = interactor.fetchRecentActivities()
            
            let (fetchedUser, fetchedActivities) = try await (userTask, activitiesTask)
            
            user = fetchedUser
            recentActivities = fetchedActivities
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadUser()
    }
    
    func logout() async {
        isLoading = true
        await interactor.performLogout()
        await router.navigateToLogin()
        isLoading = false
    }
    
    func navigateToProfile() {
        guard let userId = user?.id else { return }
        Task {
            await router.navigateToProfile(userId: userId)
        }
    }
    
    func navigateToSettings() {
        Task {
            await router.navigateToSettings()
        }
    }
    
    func navigateToActivity(_ activity: Activity) {
        Task {
            await router.navigateToActivityDetail(activityId: activity.id)
        }
    }
}
