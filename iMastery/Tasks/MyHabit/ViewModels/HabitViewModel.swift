//
//  HabitViewModel.swift
//  iMastery
//
//  Created by Saloni Singh on 22/04/25.
//

import Foundation
import UserNotifications
import CoreData

class HabitViewModel: ObservableObject {
    
    func scheduleNotification(for habit: Habit) {
        guard habit.isReminderOn,
              let habitName = habit.name,
              let reminderTime = habit.reminderTime ?? habit.time else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "⏰ Reminder"
        content.body = "Time to complete your habit: \(habitName)"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        let request = UNNotificationRequest(
            identifier: habit.id?.uuidString ?? UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification scheduling failed: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for \(habitName) at \(triggerDate.hour ?? 0):\(triggerDate.minute ?? 0)")
            }
        }
        self.printPendingNotifications()

    }
    
    func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("🔍 Pending Notifications:")
            for request in requests {
                print("• \(request.identifier) — \(request.content.title): \(request.content.body)")
            }
        }
    }

}


