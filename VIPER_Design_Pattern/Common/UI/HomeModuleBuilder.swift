//
//  HomeModuleBuilder.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

enum HomeModuleBuilder {
    @MainActor
    static func build(appRouter: AppRouter) -> some View {
        let interactor = HomeInteractor()
        let router = HomeRouter(appRouter: appRouter)
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        return HomeView(presenter: presenter)
    }
}
