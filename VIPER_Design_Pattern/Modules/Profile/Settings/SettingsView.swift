//
//  SettingsView.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct SettingsView<Presenter: SettingsPresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        List {
            // Preferences Section
            Section("Preferences") {
                Toggle("Notifications", isOn: $presenter.notificationsEnabled)
                Toggle("Dark Mode", isOn: $presenter.darkModeEnabled)
                Toggle("Biometric Authentication", isOn: $presenter.biometricEnabled)
            }
            
            // About Section
            Section("About") {
                Button(action: presenter.navigateToAbout) {
                    HStack {
                        Text("About")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
                
                Button(action: presenter.navigateToPrivacy) {
                    HStack {
                        Text("Privacy Policy")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
                
                Button(action: presenter.navigateToTerms) {
                    HStack {
                        Text("Terms of Service")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
            }
            
            // App Info Section
            Section("App Info") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(presenter.appVersion)
                        .foregroundColor(.secondary)
                }
            }
            
            // Logout Section
            Section {
                Button(action: {
                    Task {
                        await presenter.logout()
                    }
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
