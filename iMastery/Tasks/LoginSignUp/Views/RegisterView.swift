//
//  RegisterView.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 07/04/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userManager: UserManager
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var navigateToLogin = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("REGISTER HERE! ⏳")
                    .padding(.bottom, 20)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                CustomiseTextField(placeholder: "UserName", text: $username)

                CustomiseTextField(placeholder: "Email", text: $email)
                
                CustomiseTextField(placeholder: "Password", text: $password, isSecure: true)
                
                CustomButton(title: "Signup", action: {
                    let success = userManager.registerUser(name: username, email: email, password: password)
                    if success {
                        navigateToLogin = true
                    } else {
                        alertMessage = "User already registered with this email!"
                        showAlert = true
                    }
                })
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: LoginView(), label: {
                    Text("Already have an account? Login")
                        .padding()
                })
                .navigationDestination(isPresented: $navigateToLogin, destination: {
                    LoginView()
                })
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RegisterView()
}
