//
//  SettingsModuleBuilder.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

enum SettingsModuleBuilder {
    @MainActor
    static func build(appRouter: AppRouter) -> some View {
        let interactor = SettingsInteractor()
        let router = SettingsRouter(appRouter: appRouter)
        let presenter = SettingsPresenter(
            interactor: interactor,
            router: router
        )
        
        return SettingsView(presenter: presenter)
    }
}
