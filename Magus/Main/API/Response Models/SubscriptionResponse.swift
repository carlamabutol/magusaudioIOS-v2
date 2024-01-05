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
    
    let name: String
    let amountMonthly, amountYearly, period: Int
    let periodType: String
    let description: [Description]
    
    enum CodingKeys: String, CodingKey {
        case name
        case amountMonthly = "amount_monthly"
        case amountYearly = "amount_yearly"
        case period
        case periodType = "period_type"
        case description
    }
}

extension SubscriptionResponse {
    
    // MARK: - Description
    struct Description: Codable {
        let image: String
        let description: String
    }

}

struct SubscriptionErrorResponse: Decodable {
    let message: String
}
