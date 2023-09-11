//
//  SignUpResponse.swift
//  Magus
//
//  Created by Jomz on 9/5/23.
//

import Foundation

struct SignUpResponse: EndpointResponse {
    typealias ErrorResponse = SignUpErrorResponse
    
    let token: String?
    let user: UserResponse?
    let password: [String]?

    enum CodingKeys: String, CodingKey {
        case token, user, password
    }
}

struct SignUpErrorResponse: Decodable {
    let message: String
}
