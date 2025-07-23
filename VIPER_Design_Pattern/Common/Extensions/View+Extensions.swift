//
//  View+Extensions.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

extension View {
    func showAlert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.alert(title, isPresented: isPresented) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(message)
        }
    }
    
    func showLoading(_ isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .disabled(isLoading)
    }
}
