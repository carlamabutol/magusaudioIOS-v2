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
    
    var userId: String? {
        return user?.userID
    }
    
}
