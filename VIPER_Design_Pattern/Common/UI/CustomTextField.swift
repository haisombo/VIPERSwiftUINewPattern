//
//  CustomTextField.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import SwiftUI

struct CustomTextField: View {
    
    let placeholder     : String
    @Binding var text   : String
    var isSecure        : Bool = false
    var keyboardType    : UIKeyboardType = .default
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .textFieldStyle(.plain)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .autocapitalization(.none)
    }
}
