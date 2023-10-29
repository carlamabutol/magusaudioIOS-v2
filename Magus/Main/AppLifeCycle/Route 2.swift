//
//  Route.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation
import UIKit

enum Route: Equatable {
    case splashscreen
    case welcomeOnBoard
    case mood
    case home
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch lhs {
        case .splashscreen: if case .splashscreen = rhs { return true }
        case .welcomeOnBoard: if case .welcomeOnBoard = rhs { return true }
        case .mood: if case .mood = rhs { return true }
        case .home: if case .home = rhs { return true }
        }
        
        return false
    }
}
