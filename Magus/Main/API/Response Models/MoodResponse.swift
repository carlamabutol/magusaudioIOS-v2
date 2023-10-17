//
//  MoodResponse.swift
//  Magus
//
//  Created by Jomz on 6/7/23.
//

import Foundation

struct MoodResponse: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = MoodErrorResponse
    
    let id: Int
    let name, description: String
    let status: String
    let isVisible: Int?
    let image: String
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case isVisible = "is_visible"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct MoodErrorResponse: Decodable {
    let message: String
}
