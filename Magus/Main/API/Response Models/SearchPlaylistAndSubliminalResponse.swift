//
//  SearchPlaylistAndSubliminalResponse.swift
//  Magus
//
//  Created by Jomz on 7/18/23.
//

import Foundation

struct SearchPlaylistAndSubliminalResponse: EndpointResponse {
    typealias ErrorResponse = SearchPlaylistAndSubliminalErrorResponse
    
    let playlist: [SearchPlaylistResponse]
    let subliminal: [SubliminalResponse]
    
}


struct SearchPlaylistResponse: Decodable {
    
    let id: Int
    let title: String
    let cover: String
    let playlistID: String
    let description: String?
    let isVisible: Int
    let subscriptionID, userID: String
    let isFeatured: Int
    let moodsID: String?
    let categoryID, isOwnPlaylist, isLiked: Int?
    let categoryName: String
    let subliminals: [SubliminalResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case playlistID = "playlist_id"
        case description
        case isVisible = "is_visible"
        case subscriptionID = "subscription_id"
        case userID = "user_id"
        case isFeatured = "is_featured"
        case moodsID = "moods_id"
        case categoryID = "category_id"
        case isOwnPlaylist = "is_own_playlist"
        case isLiked = "is_liked"
        case categoryName = "category_name"
        case subliminals
    }
}

struct SearchSubliminalResponse: Decodable {
    let id: Int
    let playlistID, subliminalID, categoryID, subscriptionID: String
    let moodsID: String?
    let title: String
    let cover: String
    let isLiked: Int?
    let guide, description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case playlistID = "playlist_id"
        case subliminalID = "subliminal_id"
        case categoryID = "category_id"
        case subscriptionID = "subscription_id"
        case moodsID = "moods_id"
        case isLiked = "is_liked"
        case title, cover, guide, description
    }
}

struct SearchPlaylistAndSubliminalErrorResponse: Decodable {
    let message: String
}
