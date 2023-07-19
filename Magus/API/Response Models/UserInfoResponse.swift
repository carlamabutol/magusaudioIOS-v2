//
//  UserInfoResponse.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

struct UserInfoResponse: EndpointResponse {
    typealias ErrorResponse = UserInfoErrorResponse
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

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cover
        case firstName = "first_name"
        case lastName = "last_name"
        case isUserAdmin = "is_user_admin"
        case status
        case subscriptionID = "subscription_id"
        case isFirstLogin = "is_first_login"
        case subscriptionStart = "subscription_start"
        case subscriptionEnd = "subscription_end"
        case subscriptionStatus = "subscription_status"
        case categoryID = "category_id"
        case moodsID = "moods_id"
        case coverName = "cover_name"
    }
}

struct UserInfoErrorResponse: Decodable {
    let message: String
}

