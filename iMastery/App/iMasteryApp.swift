//
//  iMasteryApp.swift
//  iMastery
//
//  Created by Saloni Singh on 18/04/25.
//

import SwiftUI
import UserNotifications

@main
struct iMastery: App {
    let persistenceController = PersistenceController.shared
    @StateObject var userManager = UserManager()
    
    init(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ granted, error in
            print("Notification granted: \(granted)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userManager)
        }
    }
}

// FOR MYHABIT APP ----------------------------------------------------------------

//import SwiftUI
//import UserNotifications
//
//@main
//struct iMasteryApp: App {
//    let persistenceController = PersistenceController.shared
//    
//    init(){
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ granted, error in
//            print("Notification granted: \(granted)")
//        }
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            HabitListView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}


// FOR NOTESAPP -------------------------------------------------------------------

//import SwiftUI
//
//@main
//struct iMasteryAp: App{
//    var body: some Scene{
//        WindowGroup{
//            MainNotesView()
//        }
//    }
//}

// FOR TRAVEL JOURNAL APP ---------------------------------------------------------
//
//import SwiftUI
//
//@main
//struct iMasteryAp: App{
//    var body: some Scene{
//        WindowGroup{
//            TripListView()
//        }
//    }
//}


// FOR PODCAST PLAYER APP

//import SwiftUI
//
//@main
//struct iMastery: App {
//    var body: some Scene {
//        WindowGroup {
//            MainView()
//        }
//    }
//}


