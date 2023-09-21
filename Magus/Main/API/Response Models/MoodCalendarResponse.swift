//
//  MoodCalendarResponse.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation

struct MoodCalendarResponse: EndpointResponse {
    typealias ErrorResponse = MoodCalendarErrorResponse
    
    let date: String
    let moods: String
}

struct MoodCalendarErrorResponse: Decodable {
    let message: String
}
