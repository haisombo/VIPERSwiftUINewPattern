//
//  ProfileModuleBuilder.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

enum ProfileModuleBuilder {
    @MainActor
    static func build(userId: String, appRouter: AppRouter) -> some View {
        let interactor = ProfileInteractor()
        let router = ProfileRouter(appRouter: appRouter)
        let presenter = ProfilePresenter(
            userId: userId,
            interactor: interactor,
            router: router
        )
        
        return ProfileView(presenter: presenter)
    }
}
