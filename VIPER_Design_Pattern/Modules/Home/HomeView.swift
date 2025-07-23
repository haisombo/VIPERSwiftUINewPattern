//
//  HomeView.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct HomeView<Presenter: HomePresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // User Welcome Card
                if let user = presenter.user {
                    UserWelcomeCard(user: user)
                        .padding(.horizontal)
                }
                
                // Quick Actions
                QuickActionsSection(
                    onProfileTap: presenter.navigateToProfile,
                    onSettingsTap: presenter.navigateToSettings,
                    onLogoutTap: { showingLogoutConfirmation = true }
                )
                .padding(.horizontal)
                
                // Recent Activities
                RecentActivitiesSection(
                    activities: presenter.recentActivities,
                    onActivityTap: presenter.navigateToActivity
                )
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await presenter.refreshData()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .refreshable {
            await presenter.refreshData()
        }
        .showLoading(presenter.isLoading)
        .showAlert(
            isPresented: $presenter.showError,
            title: "Error",
            message: presenter.errorMessage
        )
        .confirmationDialog(
            "Are you sure you want to logout?",
            isPresented: $showingLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Logout", role: .destructive) {
                Task {
                    await presenter.logout()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .task {
            await presenter.loadUser()
        }
    }
}
