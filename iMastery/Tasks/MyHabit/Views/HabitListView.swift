//
//  HabitListView.swift
//  iMastery
//
//  Created by Saloni Singh on 21/04/25.
//

import SwiftUI
import UserNotifications

struct HabitListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: true)]) var habits: FetchedResults<Habit>
    @StateObject var habitViewModel = HabitViewModel()
    
    @State private var selectedHabit: Habit? = nil
    @State private var showAddHabit = false
    @State private var showStats = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(habits) { habit in
                        HStack {
                            Button(action: {
                                var log = habit.completionLog as? [Date] ?? []

                                if habit.isCompleted {
                                    // If already checked, uncheck and remove today from log
                                    habit.isCompleted = false
                                    if let index = log.lastIndex(where: { Calendar.current.isDateInToday($0) }) {
                                        log.remove(at: index)
                                    }
                                } else {
                                    // If unchecked, mark as completed and add today
                                    habit.isCompleted = true
                                    log.append(Date())
                                }

                                habit.completionLog = log as NSObject

                                do {
                                    try viewContext.save()
                                } catch {
                                    print("Failed to save context: \(error)")
                                }
                            }) {
                                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundStyle(.blue)

                            VStack(alignment: .leading) {
                                Text(habit.name ?? "")
                                Text(habit.reminderTime ?? Date(), style: .time)
                                    .font(.caption)
                            }

                            Spacer()

                            Button {
                                selectedHabit = habit
                            } label: {
                                Image(systemName: "pencil.line")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            Toggle("", isOn: Binding(
                                get: { habit.isReminderOn },
                                set: {
                                    habit.isReminderOn = $0
                                    habitViewModel.scheduleNotification(for: habit)
                                    try? viewContext.save()
                                }
                            ))
                            .controlSize(.mini)
                            .labelsHidden()
                            .tint(.blue)


                        }
                        .padding(8)
                        
                    }
                    .onDelete(perform: deleteHabits)
                }

                Spacer()
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showStats.toggle()
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }
            }
            .navigationDestination(isPresented: $showStats) {
                StatsView()
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showAddHabit.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationDestination(isPresented: $showAddHabit) {
                AddEditHabitView()
            }
            .navigationDestination(item: $selectedHabit) { habit in
                AddEditHabitView(habitToEdit: habit)
            }
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            // Just extra caution: Clear the log and save before deletion
            habit.completionLog = ([] as [Date]) as NSObject
            viewContext.delete(habit)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting habit: \(error.localizedDescription)")
        }
    }

    
}


#Preview {
    HabitListView()
}
