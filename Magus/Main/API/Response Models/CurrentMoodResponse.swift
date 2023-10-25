//
//  CurrentMoodResponse.swift
//  Magus
//
//  Created by Jomz on 10/21/23.
//

import Foundation

struct CurrentMoodResponse: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = CurrentMoodResponseErrorResponse
    
    let currentMood: String

    enum CodingKeys: String, CodingKey {
        case currentMood = "current_mood"
    }
}

struct CurrentMoodResponseErrorResponse: Decodable {
    let message: String
}

