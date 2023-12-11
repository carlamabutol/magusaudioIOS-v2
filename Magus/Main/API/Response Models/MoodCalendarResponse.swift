//
//  MoodCalendarResponse.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation

struct MoodCalendarResponse: EndpointResponse {
    typealias ErrorResponse = MoodCalendarErrorResponse
    
    let monthly, weekly: [MonthlyResponse]
}

// MARK: - Monthly
struct MonthlyResponse: EndpointResponse {
    typealias ErrorResponse = MoodCalendarErrorResponse
    let date: String
    let id: Int?
    let day: String
    let week: String
    let mood: MoodResponse?
}

struct MoodCalendarErrorResponse: Decodable {
    let message: String
}
