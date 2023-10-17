//
//  DefaultResponse.swift
//  Magus
//
//  Created by Jomz on 6/13/23.
//

import Foundation

struct DefaultResponse: EndpointResponse {
    typealias ErrorResponse = DefaultErrorResponse
    
    let code: Int
    let message: String
}

struct DefaultErrorResponse: Decodable {
    let message: String
}
