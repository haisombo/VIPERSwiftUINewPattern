//
//  LoginView.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

@preconcurrency import SwiftUI

struct LoginView<Presenter: LoginPresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Logo
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            // Title
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Form
            VStack(spacing: 16) {
                CustomTextField(
                    placeholder: "Email",
                    text: $presenter.email,
                    keyboardType: .emailAddress
                )
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                
                CustomTextField(
                    placeholder: "Password",
                    text: $presenter.password,
                    isSecure: true
                )
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    Task { @MainActor in
                        await presenter.login()
                    }
                }
            }
            
            // Login Button
            Button {
                Task { @MainActor in
                    await presenter.login()
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(presenter.isLoading)
            
            // Forgot Password
            Button(action: presenter.navigateToForgotPassword) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Register
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Button(action: presenter.navigateToRegister) {
                    Text("Register")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .showLoading(presenter.isLoading)
        .showAlert(
            isPresented: $presenter.showError,
            title: "Error",
            message: presenter.errorMessage
        )
        .onTapGesture {
            focusedField = nil
        }
    }
}

