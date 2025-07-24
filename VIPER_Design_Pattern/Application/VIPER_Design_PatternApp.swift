//
//  VIPER_Design_PatternApp.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

@main
struct VIPERSwiftUIApp: App {
    @StateObject private var appRouter = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.path) {
                LoginModuleBuilder.build(appRouter: appRouter)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .home:
                            HomeModuleBuilder.build(appRouter: appRouter)
                        case .login:
                            LoginModuleBuilder.build(appRouter: appRouter)
                        case .profile(let userId):
                            ProfileModuleBuilder.build(userId: userId, appRouter: appRouter)
                        case .settings:
                            SettingsModuleBuilder.build(appRouter: appRouter)
                        case .detailProduct(let Id) :
                            DetailProModuleBuilder.build(appRouter: appRouter)
                        }
                    }
            }
            .environmentObject(appRouter)
            .onAppear {
                setupAppearance()
            }
        }
    }
    
    private func setupAppearance() {
       print("setupAppearance New List ")
    }
}
