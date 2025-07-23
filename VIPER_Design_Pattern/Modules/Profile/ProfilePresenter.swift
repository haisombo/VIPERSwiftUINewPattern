//
//  ProfilePresenter.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

@MainActor
final class ProfilePresenter: ProfilePresenterProtocol {
    @Published var user: User?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let userId: String
    private let interactor: ProfileInteractorProtocol
    private let router: ProfileRouterProtocol
    
    nonisolated init(
        userId: String,
        interactor: ProfileInteractorProtocol,
        router: ProfileRouterProtocol
    ) {
        self.userId = userId
        self.interactor = interactor
        self.router = router
    }
    
    func loadUserProfile() async {
        isLoading = true
        
        do {
            user = try await interactor.fetchUserProfile(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    func navigateBack() {
        Task {
            await router.navigateBack()
        }
    }
    
    func navigateToEditProfile() {
        Task {
            await router.navigateToEditProfile(userId: userId)
        }
    }
}
