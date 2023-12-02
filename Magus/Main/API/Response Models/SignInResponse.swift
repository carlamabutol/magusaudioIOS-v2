//
//  SignInResponse.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

struct SignInResponse: EndpointResponse {
    typealias ErrorResponse = SignInErrorResponse
    
    let token: String
    let user: UserResponse

    enum CodingKeys: String, CodingKey {
        case token, user
    }
}

struct SignInErrorResponse: Decodable {
    let message: String
}


extension String: EndpointResponse {
    typealias ErrorResponse = SignInErrorResponse
}
