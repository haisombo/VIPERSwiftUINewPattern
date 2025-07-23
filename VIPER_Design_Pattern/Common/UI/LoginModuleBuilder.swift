//
//  LoginModuleBuilder.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

enum LoginModuleBuilder {
    @MainActor
    static func build(appRouter: AppRouter) -> some View {
        let interactor = LoginInteractor()
        let router = LoginRouter(appRouter: appRouter)
        let presenter = LoginPresenter(interactor: interactor, router: router)
        
        return LoginView(presenter: presenter)
    }
}
