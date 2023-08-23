//
//  PlaylistSubliminalResponse.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation


struct PlaylistSubliminalResponse: EndpointResponse {
    typealias ErrorResponse = PlaylistSubliminalErrorResponse
    
    let id: Int
    let subliminalID, title: String
    let cover: String
    let description: String
    let isFeatured, isVisible: Int?
    let subscriptionID, createdAt, updatedAt: String
    let guide, moodsID: String?
    let trackInfo: [SubliminalInfoResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case subliminalID = "subliminal_id"
        case title, cover, description
        case isFeatured = "is_featured"
        case isVisible = "is_visible"
        case subscriptionID = "subscription_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case guide
        case moodsID = "moods_id"
        case trackInfo = "track_info"
    }
}

struct PlaylistSubliminalErrorResponse: Decodable {
    let message: String
}
