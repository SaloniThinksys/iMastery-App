//
//  CustomAlert.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 08/04/25.
//

import SwiftUI

struct CustomAlert: View {
    var title: String
    var message: String
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20){
            Text(title)
                .font(.title2)
                .bold()
            
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("OK") {
                onDismiss()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(40)
    }
}


