//
//  CustomButton.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 08/04/25.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color = .black
    var foregroundColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textCase(.uppercase)
                .padding(15)
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .foregroundColor(foregroundColor)
        }
    }
}

