//
//  ContentView.swift
//  iMastery
//
//  Created by Saloni Singh on 18/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                HabitListView()
                    .tabItem {
                        Label("My Habit", systemImage: "chart.bar.fill")
                    }
                
                MainView()
                    .tabItem {
                        Label("Podcast Player", systemImage: "microphone")
                    }
                
                TripListView()
                    .tabItem {
                        Label("Travel Journal", systemImage: "airplane.departure")
                        
                    }
            }
    }
}

#Preview {
    ContentView()
}
