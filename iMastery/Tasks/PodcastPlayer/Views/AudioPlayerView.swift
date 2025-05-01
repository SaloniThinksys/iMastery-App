//
//  MainView.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import SwiftUI

import SwiftUI

struct AudioPlayerView: View {
    let tracks: [AudioTrack]
    let startIndex: Int

    @StateObject private var viewModel = AudioPlayerViewModel()
    @ObservedObject var savedManager = SavedTracksManager.shared
    @State private var animateEntry = false
    @State private var animatePlayPause = false
    

    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient.purpleGradient.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if let current = viewModel.currentTrack {
                        Image(current.imageName)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 10)
                            .transition(.scale.combined(with: .opacity))
                            .id(current.id)
                        
                        Text(current.title)
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .slide))
                            .id(current.id)
                    }
                    
                    // ⏱️ Slider
                    Slider(value: Binding(
                        get: { viewModel.currentTime },
                        set: { viewModel.seek(to: $0) }
                    ), in: 0...viewModel.duration)
                    .tint(.white)
                    
                    // Time Labels
                    HStack {
                        Text(formatTime(viewModel.currentTime))
                        Spacer()
                        Text(formatTime(viewModel.duration))
                    }
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    
                    // Media Controls
                    HStack(spacing: 30) {
                        // Shuffle
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.shuffleTracks()
                            }
                        }) {
                            Image(systemName: viewModel.isShuffled ? "shuffle.circle.fill" : "shuffle.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        // Prev
                        Button(action: {
                            withAnimation {
                                viewModel.playPrevious()
                            }
                        }) {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        // Play / Pause
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.playOrPause()
                                animatePlayPause.toggle()
                            }
                        }) {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 65, height: 65)
                                .scaleEffect(animatePlayPause ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animatePlayPause)
                        }
                        
                        // Next
                        Button(action: {
                            withAnimation {
                                viewModel.playNext()
                            }
                        }) {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        // Bookmark
                        Button(action: {
                            if let track = viewModel.currentTrack {
                                withAnimation(.easeInOut) {
                                    savedManager.toggleSave(for: track)
                                }
                            }
                        }) {
                            Image(systemName: savedManager.isSaved(viewModel.currentTrack ?? AudioTrack(title: "", fileName: "", imageName: "")) ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 30))
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.top)
                }
                .padding()
                .opacity(animateEntry ? 1 : 0)
                .offset(y: animateEntry ? 0 : 60)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        animateEntry = true
                    }
                    viewModel.loadTracks(tracks, startAt: startIndex)
                }
                .navigationTitle("🎧 Playing...")
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
