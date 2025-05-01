//
//  MainView.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import SwiftUI

struct AudioListView: View {
    @State private var selectedTrack: AudioTrack? = nil
    let tracks = sampleTracks

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.purpleGradient.ignoresSafeArea()
                List(tracks) { track in
                    HStack {
                        Image(track.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(track.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(0.95)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedTrack = track
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color.white) // needed for clipping to apply to visible content
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
                .padding()
                .navigationTitle("🎙️ Audio List")
                .sheet(item: $selectedTrack) { track in
                    if let index = tracks.firstIndex(where: { $0.id == track.id }) {
                        AudioPlayerView(tracks: tracks, startIndex: index)
                    }
                }
            }
        }
    }
}

