//
//  iMasteryApp.swift
//  iMastery
//
//  Created by Saloni Singh on 18/04/25.
//

import SwiftUI
import UserNotifications

@main
struct iMasteryApp: App {
    let persistenceController = PersistenceController.shared
    
    init(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ granted, error in
            print("Notification granted: \(granted)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
