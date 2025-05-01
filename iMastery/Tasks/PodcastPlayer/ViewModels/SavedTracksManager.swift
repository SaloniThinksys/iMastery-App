//
//  SavedTracksManager.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import Foundation

class SavedTracksManager: ObservableObject {
    static let shared = SavedTracksManager()

    @Published var savedTracks: [AudioTrack] = []

    private let saveKey = "saved_tracks"

    private init() {
        loadSavedTracks()
    }

    func toggleSave(for track: AudioTrack) {
        if let index = savedTracks.firstIndex(of: track) {
            savedTracks.remove(at: index)
        } else {
            savedTracks.append(track)
        }
        saveTracks()
    }

    func isSaved(_ track: AudioTrack) -> Bool {
        return savedTracks.contains(track)
    }

    private func saveTracks() {
        if let data = try? JSONEncoder().encode(savedTracks) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func remove(_ track: AudioTrack) {
        savedTracks.removeAll { $0.id == track.id }
    }

    private func loadSavedTracks() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([AudioTrack].self, from: data) {
            savedTracks = decoded
        }
    }
}
