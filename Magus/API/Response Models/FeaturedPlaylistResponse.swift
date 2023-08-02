//
//  FeaturedPlaylist.swift
//  Magus
//
//  Created by Jomz on 7/1/23.
//

import Foundation

struct FeaturedPlaylistResponse: EndpointResponse {
    typealias ErrorResponse = FeaturedPlaylistErrorResponse
    
    let id: Int
    let title: String
    let cover: String
    let playlistID: String
    let description: String?
    let isVisible: Int
    let subscriptionID, userID: String
    let isFeatured: Int
    let createdAt, updatedAt: String
    let moodsID, categoryID: String?
    let isOwnPlaylist, isLiked: Int?
    let info: [PlaylistInfo]

    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case playlistID = "playlist_id"
        case description
        case isVisible = "is_visible"
        case subscriptionID = "subscription_id"
        case userID = "user_id"
        case isFeatured = "is_featured"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case moodsID = "moods_id"
        case categoryID = "category_id"
        case isOwnPlaylist = "is_own_playlist"
        case isLiked = "is_liked"
        case info
    }
}

struct PlaylistInfo: Decodable {
    let id: Int
    let playlistID, subliminalID, categoryID, subscriptionID: String
    let createdAt, updatedAt, moodsID, title: String
    let cover: String
    let guide, description: String
    let trackInfo: [TrackInfo]

    enum CodingKeys: String, CodingKey {
        case id
        case playlistID = "playlist_id"
        case subliminalID = "subliminal_id"
        case categoryID = "category_id"
        case subscriptionID = "subscription_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case moodsID = "moods_id"
        case title, cover, guide, description
        case trackInfo = "track_info"
    }
}

struct TrackInfo: Codable, Hashable {
    let id: Int
    let subliminalID, trackID: String
    let version, audioTypeID, volume: Int
    let createdAt, updatedAt, trackTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case subliminalID = "subliminal_id"
        case trackID = "track_id"
        case version
        case audioTypeID = "audio_type_id"
        case volume
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case trackTitle = "track_title"
    }
}

struct FeaturedPlaylistErrorResponse: Decodable {
    let message: String
}


