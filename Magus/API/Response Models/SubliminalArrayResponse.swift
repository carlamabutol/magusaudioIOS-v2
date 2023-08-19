//
//  SubliminalResponse.swift
//  Magus
//
//  Created by Jomz on 7/2/23.
//

import Foundation

struct SubliminalArrayResponse: EndpointResponse {
    typealias ErrorResponse = SubliminalErrorResponse
    
    let data: [SubliminalResponse]
}

struct SubliminalResponse: EndpointResponse {
    typealias ErrorResponse = SubliminalErrorResponse
    
    let id: Int
    let subliminalID, title: String
    let cover: String
    let description: String
    let isFeatured, isVisible: Int?
    let subscriptionID, createdAt, updatedAt: String
    let guide, moodsID: String?
    let info: [SubliminalInfoResponse]

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
        case info
    }
}

struct SubliminalErrorResponse: Decodable {
    let message: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Info
struct SubliminalInfoResponse: Codable, Hashable {
    let id: Int
    let subliminalID, trackID: String
    let version, audioTypeID, volume: Int
    let trackTitle, link: String?

    enum CodingKeys: String, CodingKey {
        case id
        case subliminalID = "subliminal_id"
        case trackID = "track_id"
        case version
        case audioTypeID = "audio_type_id"
        case volume
        case trackTitle = "track_title"
        case link
    }
}
