//
//  Recommendations.swift
//  Magus
//
//  Created by Jomz on 9/3/23.
//

import Foundation

struct RecommendationResponse: EndpointResponse {
    typealias ErrorResponse = RecommendationResponseErrorResponse
    
    let subliminal: [SubliminalResponse]
    
}

struct RecommendationResponseErrorResponse: Decodable {
    let message: String
}

