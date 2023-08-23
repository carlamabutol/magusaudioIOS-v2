//
//  MoodResponse.swift
//  Magus
//
//  Created by Jomz on 6/7/23.
//

import Foundation

struct MoodResponse : EndpointResponse {
    typealias ErrorResponse = MoodResponseErrorResponse
    let code: Int
    let data: [Mood]
}

struct MoodResponseErrorResponse: Decodable {
    let message: String
}

struct Mood: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = MoodResponseErrorResponse
    
    let id: Int
    let name, description: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, image
    }
}
