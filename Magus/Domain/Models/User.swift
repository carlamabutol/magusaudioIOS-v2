//
//  User.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

// MARK: - User
struct User: Codable, Equatable {
    let id: Int
    let name, userID, email: String
    let createdAt: String
    let info: UserInfo
}
