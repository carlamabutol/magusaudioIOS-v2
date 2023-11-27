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
    let subliminalID: String
    let title: String?
    let playlistId: String?
    let cover: String
    let description: String?
    let isFeatured, isVisible, isLiked: Int?
    let subscriptionID: String?
    let guide, moodsID: String?
    let tracks: [SubliminalInfoResponse]?

    enum CodingKeys: String, CodingKey {
        case id
        case subliminalID = "subliminal_id"
        case playlistId = "playlist_id"
        case title, cover, description
        case isFeatured = "is_featured"
        case isVisible = "is_visible"
        case isLiked = "is_liked"
        case subscriptionID = "subscription_id"
        case guide
        case moodsID = "moods_id"
        case tracks
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
    let title, link: String?
    let duration: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case subliminalID = "subliminal_id"
        case trackID = "track_id"
        case version
        case audioTypeID = "audio_type_id"
        case volume
        case title
        case link
        case duration
    }
}
