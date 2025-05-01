//
//  LibraryView.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var savedManager = SavedTracksManager.shared
    @State private var selectedTrack: AudioTrack? = nil
    let tracks = sampleTracks

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.purpleGradient.ignoresSafeArea()
                List{
                    ForEach(savedManager.savedTracks){ track in
                        HStack {
                            Image(track.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(track.title)
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedTrack = track
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .background(Color.white) // needed for clipping to apply to visible content
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 6)
                .padding()
                .navigationTitle("💾 Saved Audios")
                .sheet(item: $selectedTrack) { track in
                    if let index = savedManager.savedTracks.firstIndex(of: track) {
                        AudioPlayerView(tracks: savedManager.savedTracks, startIndex: index)
                    }
                }
            }
        }
    }
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let track = savedManager.savedTracks[index]
            savedManager.remove(track)
        }
    }
}



#Preview {
    LibraryView()
}
