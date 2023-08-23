//
//  UserInfo.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

// MARK: - Info
struct UserInfo: Codable, Equatable {
    let id: Int
    let userID: String
    let cover: String?
    let firstName: String
    let lastName: String
    let isUserAdmin: Int
    let status: Int
    let isFirstLogin: Int
    let subscriptionID: Int?
    let subscriptionStart, subscriptionEnd: String?
    let subscriptionStatus: Int?
    let categoryID: Int?
    let moodsID: String?
    let coverName: String?
}
