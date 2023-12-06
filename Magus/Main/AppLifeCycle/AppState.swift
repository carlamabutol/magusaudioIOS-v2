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
    var selectedSubliminal: Subliminal?
    var allMoods: [Mood] = []
    
    var userId: String? {
        return user?.userID
    }
    
    var playlistQueue: [Subliminal] = []
    var subliminalQueue: [Subliminal] = []
    var addedQueue: [Subliminal] = []
    
    var playerState: PlayerState = .isPaused
    var playerRepeatAll: Bool = false
 
    enum PlayerState: Int, Codable, Hashable, Equatable {
        case isPlaying
        case isPaused
    }
}
