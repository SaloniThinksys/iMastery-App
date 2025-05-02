//
//  ContentView.swift
//  iMastery
//
//  Created by Saloni Singh on 18/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    @Namespace private var animation
    
    var body: some View {
            TabView(selection: $tabSelection) {
                iMasteryMainView()
                    .tag(1)
                
                LoginView()
                    .tag(2)
                
                HabitListView()
                    .tag(3)
                
                MainView()
                    .tag(4)
                
                TripListView()
                    .tag(5)
            }
            .overlay(alignment: .bottom){
                CustomTabBar(tabSelection: $tabSelection, animation: animation)
            }
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
