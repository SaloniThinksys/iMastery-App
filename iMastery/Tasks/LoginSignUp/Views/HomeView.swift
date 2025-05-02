//
//  HomeView.swift
//  Login_Signup_Task1
//
//  Created by Saloni Singh on 07/04/25.
//

import SwiftUI

struct HomeView: View {
    let currentUser: UserModel
    @ObservedObject var userManager: UserManager
    
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
        
    var body: some View {
        NavigationStack{
            VStack() {
                Text("Welcome, \(currentUser.name)!")
                    .font(.title2.bold())
                    .foregroundStyle(.blue)
                    .shadow(radius: 10)
                    .padding()
                List{
                    ForEach(userManager.users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline)
                        }
                    }
                    .onDelete { offsets in
                        // Save the indexSet and show the confirmation alert
                        indexSetToDelete = offsets
                        showDeleteConfirmation = true
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
        .navigationTitle("All Registered Users")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                   // logOut()
                }, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.caption.bold())
                        .foregroundStyle(.red)
                        .shadow(radius: 10)
                })
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let offsets = indexSetToDelete {
                        deleteUser(at: offsets)
                        indexSetToDelete = nil
                    }
                },
                secondaryButton: .cancel {
                    indexSetToDelete = nil
                }
            )
        }
    }
    
    //delete the user
    func deleteUser(at offsets: IndexSet) {
        userManager.users.remove(atOffsets: offsets)
        userManager.saveUsers()
    }

}

