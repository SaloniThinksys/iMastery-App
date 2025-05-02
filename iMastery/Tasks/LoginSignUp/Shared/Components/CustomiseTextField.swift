//
//  CustomiseTextField.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 08/04/25.
//

import SwiftUI

struct CustomiseTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(placeholder.lowercased().contains("email") ? .emailAddress : .default)
            }
        }
    }
}

