//
//  SignInResponse.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation


struct SignInResponse: EndpointResponse {
    typealias ErrorResponse = SignInErrorResponse
    
    let success: Bool
    let token: String?
    let user: User?
}

struct SignInErrorResponse: Decodable {
    let message: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - User
struct User: Codable, Equatable {
    let id: Int
    let name, userID, email: String
//    let emailVerifiedAt: Int?
    let createdAt: String
//    let provider, providerID: Int?
    let info: Info

    enum CodingKeys: String, CodingKey {
        case id, name
        case userID = "user_id"
        case email
//        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
//        case provider
//        case providerID = "provider_id"
        case info
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Info
struct Info: Codable, Hashable {
    let id: Int
    let userID: String
    let cover: String
    let firstName, lastName: String
    let isUserAdmin, status, subscriptionID, isFirstLogin: Int
    let subscriptionStart, subscriptionEnd: String
    let subscriptionStatus: Int
    let categoryID, moodsID, coverName: String

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
