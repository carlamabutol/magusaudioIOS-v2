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
    var selectedCategory: Category?
    var subliminals: [Subliminal] = []
    var selectedSubliminal: Subliminal?
    var allMoods: [Mood] = []
    
    var userId: String? {
        return user?.userID
    }
    
    var playerState: PlayerState = .isPaused
    var isRepeatAll: Bool = false
 
    enum PlayerState: Int, Codable, Hashable, Equatable {
        case isPlaying
        case isPaused
    }
}
