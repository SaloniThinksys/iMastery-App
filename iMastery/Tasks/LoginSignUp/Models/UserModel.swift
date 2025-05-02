//
//  UserModel.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 07/04/25.
//

import Foundation

struct UserModel : Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let email: String
    let password: String
}
