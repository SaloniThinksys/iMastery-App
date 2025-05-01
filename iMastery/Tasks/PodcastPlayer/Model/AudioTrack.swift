//
//  Model.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import Foundation

struct AudioTrack: Identifiable, Codable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let fileName: String
    let imageName: String
}

let sampleTracks: [AudioTrack] = [
  AudioTrack(title: "Audio Player 1", fileName: "audio1", imageName: "audio1"),
  AudioTrack(title: "Audio Player 2", fileName: "audio2", imageName: "audio2"),
  AudioTrack(title: "Audio Player 3", fileName: "audio3", imageName: "audio3"),
  AudioTrack(title: "Audio Player 4", fileName: "audio4", imageName: "audio4"),
  AudioTrack(title: "Audio Player 5", fileName: "audio5", imageName: "audio5"),
  AudioTrack(title: "Audio Player 6", fileName: "audio6", imageName: "audio6"),
  AudioTrack(title: "Wo Ajnabee", fileName: "Wo Ajnabee", imageName: "Wo Ajnabee")
]

