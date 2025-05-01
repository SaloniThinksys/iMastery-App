//
//  AudioPlayerViewModel.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
  var audioPlayer: AVAudioPlayer?
  var timer: Timer?

  @Published var isPlaying = false
  @Published var currentTime: TimeInterval = 0
  @Published var duration: TimeInterval = 0
  @Published var currentTrack: AudioTrack?
  @Published var isShuffled = false
    
    private var originalTracks: [AudioTrack] = []
    var allTracks: [AudioTrack] = []
    var currentIndex: Int = 0

  // No audio loading in init anymore
  //init() {}
    
    
    func loadTracks(_ tracks: [AudioTrack], startAt index: Int) {
      self.originalTracks = tracks
      self.allTracks = tracks
      self.currentIndex = index
      self.currentTrack = tracks[index]
      loadAudio(named: tracks[index].fileName)
    }

  // Call this when a user selects an audio track
  func loadAudio(named fileName: String) {
    stopTimer() // Stop any ongoing timer/audio

    if let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
      do {
        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        self.audioPlayer?.delegate = self
        self.audioPlayer?.prepareToPlay()
        self.duration = self.audioPlayer?.duration ?? 0
        self.currentTime = 0
        if isPlaying {
          audioPlayer?.play()
          startTimer()
        }
      } catch {
        print("AVAudioPlayer could not be instantiated for file: \(fileName)")
      }
    } else {
      print("Audio file '\(fileName)' could not be found.")
    }
  }

  func playOrPause() {
    guard let player = audioPlayer else { return }

    if player.isPlaying {
      player.pause()
      isPlaying = false
      stopTimer()
    } else {
      player.play()
      isPlaying = true
      startTimer()
    }
  }

  func seek(to time: TimeInterval) {
    guard let player = audioPlayer else { return }
    player.currentTime = time
    currentTime = time
  }
    
    func playNext(){
        guard currentIndex < allTracks.count - 1 else { return }
        currentIndex += 1
        loadTracks(allTracks, startAt: currentIndex)
        isPlaying = true
        audioPlayer?.play()
        startTimer()
    }
    
    func playPrevious(){
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        loadTracks(allTracks, startAt: currentIndex)
        isPlaying = true
        audioPlayer?.play()
        stopTimer()
    }
    
    func shuffleTracks(){
        isShuffled.toggle()
        
        if isShuffled{
            let current = allTracks[currentIndex]
            allTracks.shuffle()
            
            if let newIndex = allTracks.firstIndex(where: {$0.id == current.id}){
                currentIndex = newIndex
            }
        } else{
            if currentIndex >= 0 && currentIndex < allTracks.count {
                let current = allTracks[currentIndex]
                if let newIndex = originalTracks.firstIndex(where: { $0.id == current.id }) {
                    allTracks = originalTracks
                    currentIndex = newIndex
                }
            }
        }
        playTrack(at: currentIndex)
    }
    
    private func playNextShuffled() {
        guard !allTracks.isEmpty else { return }

        var nextIndex = currentIndex

        // Keep picking until it's a new track
        repeat {
            nextIndex = Int.random(in: 0..<allTracks.count)
        } while nextIndex == currentIndex && allTracks.count > 1

        currentIndex = nextIndex
        playTrack(at: currentIndex)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isShuffled {
            playNextShuffled()
        } else {
            playNext()
        }
    }

    
    private func playTrack(at index: Int){
        guard index >= 0 && index < allTracks.count else { return }
        currentTrack = allTracks[index]
        loadAudio(named: currentTrack!.fileName)
        isPlaying = true
        audioPlayer?.play()
        startTimer()
    }

  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
      guard let player = self.audioPlayer else { return }
      self.currentTime = player.currentTime
    }
  }

  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
}
