//
//  AddEditHabitView.swift
//  iMastery
//
//  Created by Saloni Singh on 21/04/25.
//

import SwiftUI

struct AddEditHabitView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @StateObject var habitViewModel = HabitViewModel()

    @State private var name: String = ""
    @State private var time: Date = Date()
    @State private var isReminderOn = true
    var habitToEdit: Habit? = nil

    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: .leading, spacing: 10){
                        Text("Habit Name")
                        Divider()
                        TextField("Write here....", text: $name)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                    
                    Section{
                        DatePicker("Reminder Time", selection: $time, displayedComponents: .hourAndMinute)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Section{
                        Toggle("Enable Reminder", isOn: $isReminderOn)
                            .tint(.blue)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                
                Spacer()
                
                Button("Save Habit") {
                    let habit = habitToEdit ?? Habit(context: context)
                    habit.name = name
                    habit.reminderTime = time
                    habit.isReminderOn = isReminderOn

                    if habitToEdit == nil {
                        habit.id = UUID()
                        habit.createdDate = Date()
                        habit.completionLog = ([] as [Date]) as NSObject
                    }

                    try? context.save()
                    habitViewModel.scheduleNotification(for: habit)
                    dismiss()
                }
                .padding()
                .bold()
                .frame(maxWidth: .infinity)
                .background(Color.blue.cornerRadius(10))
                .foregroundColor(.white)
            }
            .padding()
            .navigationTitle(habitToEdit == nil ? "Add New Habit" : "Edit Habit")
            .onAppear {
                if let habit = habitToEdit {
                    name = habit.name ?? ""
                    time = habit.reminderTime ?? Date()
                    isReminderOn = habit.isReminderOn
                }
            }

        }

    }
}


#Preview {
    AddEditHabitView()
}
