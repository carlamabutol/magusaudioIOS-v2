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
    let isOwnPlaylist, isLiked: Int

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
    }
}

struct FeaturedPlaylistErrorResponse: Decodable {
    let message: String
}


