//
//  UserResponse.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

struct UserResponse: EndpointResponse {
    typealias ErrorResponse = UserErrorResponse
    
    let id: Int
    let name, userID, email: String
    let createdAt: String
    let info: UserInfoResponse

    enum CodingKeys: String, CodingKey {
        case id, name
        case userID = "user_id"
        case email
        case createdAt = "created_at"
        case info
    }
}

struct UserErrorResponse: Decodable {
    let message: String
}
