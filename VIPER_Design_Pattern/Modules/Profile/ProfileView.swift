//
//  ProfileView.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct ProfileView<Presenter: ProfilePresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let user = presenter.user {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.blue)
                        
                        Text(user.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Profile Info
                    VStack(alignment: .leading, spacing: 16) {
                        ProfileInfoRow(title: "User ID", value: user.id)
                        ProfileInfoRow(title: "Email", value: user.email)
                        ProfileInfoRow(title: "Name", value: user.name)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Edit Button
                    Button(action: presenter.navigateToEditProfile) {
                        Text("Edit Profile")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .showLoading(presenter.isLoading)
        .showAlert(
            isPresented: $presenter.showError,
            title: "Error",
            message: presenter.errorMessage
        )
        .task {
            await presenter.loadUserProfile()
        }
    }
}


struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}
