//
//  SubscriptionResponse.swift
//  Magus
//
//  Created by Jomz on 7/9/23.
//

import Foundation

// MARK: - Mood
struct SubscriptionResponse: EndpointResponse {
    typealias ErrorResponse = SubscriptionErrorResponse
    
    let id: Int
    let name, description, createdAt, updatedAt: String
    let amount, period: Int
    let periodType: String
    let isVisible, amountYear: Int

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case amount, period
        case periodType = "period_type"
        case isVisible = "is_visible"
        case amountYear = "amount_year"
    }
}

struct SubscriptionErrorResponse: Decodable {
    let message: String
}
