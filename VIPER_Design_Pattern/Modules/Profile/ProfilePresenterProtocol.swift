//
//  ProfilePresenterProtocol.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@MainActor
protocol ProfilePresenterProtocol: ObservableObject {
    var user: User? { get }
    var isLoading: Bool { get }
    var showError: Bool { get set }
    var errorMessage: String { get }
    
    func loadUserProfile() async
    func navigateBack()
    func navigateToEditProfile()
}

protocol ProfileInteractorProtocol: Sendable {
    func fetchUserProfile(userId: String) async throws -> User
}

protocol ProfileRouterProtocol: Sendable {
    func navigateBack() async
    func navigateToEditProfile(userId: String) async
}
