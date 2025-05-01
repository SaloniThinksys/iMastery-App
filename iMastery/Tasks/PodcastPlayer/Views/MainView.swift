//
//  MainView.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        ZStack {
            LinearGradient.purpleGradient.ignoresSafeArea()
            TabView {
                AudioListView()
                    .tabItem {
                        Label("Audio", systemImage: "waveform")
                    }

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "bookmark.fill")
                            
                    }
            }
            .accentColor(.white)
        }
    }
}

#Preview {
    MainView()
}
