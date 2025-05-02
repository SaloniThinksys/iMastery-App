//
//  LoginView.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 07/04/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var currentUser: UserModel?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State var email: String = ""
    @State var password: String = ""
    @State private var isNavigating: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("LOGIN HERE! 🗝️")
                    .padding(.bottom, 20)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                CustomiseTextField(placeholder: "Email", text: $email)
                
                CustomiseTextField(placeholder: "Password", text: $password, isSecure: true)
                
                CustomButton(title: "Login", action: {
                    loginUser()
                })
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: RegisterView(), label: {
                    Text("Don't have an Account? Signup")
                        .padding()
                })
                .navigationDestination(isPresented: $isNavigating, destination: {
                    if let user = currentUser {
                        HomeView(currentUser: user, userManager: userManager)
                    } else {
                        Text("Error loading user") // Or show a fallback
                    }
                })
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }

        
    }
    private func loginUser() {
        let existingUser = userManager.getUser(byEmail: email)
        
        if existingUser == nil {
            alertMessage = "User not registered"
            showAlert = true
        } else if existingUser?.password != password {
            alertMessage = "Invalid Credentials"
            showAlert = true
        } else {
            currentUser = existingUser
            isNavigating = true
        }
    }
}

#Preview {
    LoginView().environmentObject(UserManager())
}
