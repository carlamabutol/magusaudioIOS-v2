//
//  Route.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation
import UIKit

enum Route: Equatable {
    case welcome
    case login
    case home
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch lhs {
        case .welcome: if case .welcome = rhs { return true }
        case .login: if case .login = rhs { return true }
        case .home: if case .home = rhs { return true }
        }
        
        return false
    }
}
