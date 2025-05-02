//
//  UserViewModel.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 07/04/25.
//

import SwiftUI
import Foundation

class UserManager : ObservableObject {  //make this class observable to all swiftUI views
    @Published var users: [UserModel] = []  // any change in users automatically refresh the ui
    private let fileName = "users.json"  //We store all users in a users.json file locally in the app’s Documents directory
    
    init(){
        loadUsers()
    }
    
    private func getFilePath() -> URL {  //adding file to the path
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
    }
    
    func loadUsers() {
        let path = getFilePath()
        if let data = try? Data(contentsOf: path){
            if let decoded = try? JSONDecoder().decode([UserModel].self, from: data) {
                self.users = decoded
            }
        }
    }
        
    func saveUsers(){
        let data = try? JSONEncoder().encode(users)   //first encode data
        try? data?.write(to: getFilePath())         //then write to the file
    }
        
    func registerUser(name: String,email: String, password: String) -> Bool {
        if users.contains(where: {$0.email == email}){
            return false //already registered
        }
        let newUser = UserModel(name: name, email: email, password: password)
        users.append(newUser)
        saveUsers()
        return true
    }
    
    func authenticate(email: String, password: String) -> UserModel? {
        return users.first(where: {$0.email == email && $0.password == password})
    }
    
    func getUser(byEmail email: String) -> UserModel? {
        return users.first { $0.email == email }
    }
        
    
}


