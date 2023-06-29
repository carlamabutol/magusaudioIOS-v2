//
//  AppState.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation

struct AppState: Codable, Equatable {
    
    var userId: String? {
        return user?.userID
    }
    
    var user: User?
    var selectedMood: Mood?
    
}
