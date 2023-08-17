//
//  AudioAVPlayer.swift
//  Magus
//
//  Created by Jomz on 8/15/23.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var audioPlayers: [URL: AudioPlayer] = [:]

    private init() {}

    func createAudioPlayer(with url: URL) -> AudioPlayer {
        if let existingPlayer = audioPlayers[url] {
            return existingPlayer
        }
        
        let newPlayer = AudioPlayer(url: url)
        audioPlayers[url] = newPlayer
        return newPlayer
    }
    
    func removeAudioPlayer(for url: URL) {
        audioPlayers[url] = nil
    }
    
    func playAllAudioPlayers() {
        if audioPlayers.first?.value.isPlaying == true {
            for (_, player) in audioPlayers {
                player.pause()
            }
        } else {
            for (_, player) in audioPlayers {
                player.play()
            }
        }
    }
    
    func pauseAllAudioPlayers() {
        for (_, player) in audioPlayers {
            player.pause()
        }
    }
    
    func removePlayers() {
        audioPlayers.removeAll()
    }
}
