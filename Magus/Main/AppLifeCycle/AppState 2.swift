//
//  AppState.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation

struct AppState: Codable, Equatable {
    
    var user: User?
    var selectedMood: Mood?
    var subliminals: [Subliminal] = []
    var selectedSubliminal: Subliminal?
    
    var userId: String? {
        return user?.userID
    }
    
    var playerState: PlayerState = .isPaused
    var isRepeatAll: Bool = false
 
    enum PlayerState: Codable {
        case isPlaying
        case isPaused
    }
}
