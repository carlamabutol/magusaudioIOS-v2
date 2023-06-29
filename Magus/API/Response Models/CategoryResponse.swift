//
//  CategoryResponse.swift
//  Magus
//
//  Created by Jose Mari Pascual on 6/20/23.
//

import Foundation

struct CategorySubliminalResponse : EndpointResponse {
    typealias ErrorResponse = CategorySubliminalErrorResponse
    let data: [CategorySubliminalElement]
}

struct CategorySubliminalErrorResponse: Decodable {
    let message: String
}

// MARK: - CategorySubliminalElement
struct CategorySubliminalElement: EndpointResponse {
    typealias ErrorResponse = CategorySubliminalErrorResponse
    let id: Int
    let name: String
    let description: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image
    }
}
