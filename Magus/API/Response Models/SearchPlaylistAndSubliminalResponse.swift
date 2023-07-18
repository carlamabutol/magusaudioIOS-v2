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
    let subliminal: [SearchSubliminalResponse]
    
}

struct SearchPlaylistResponse: Decodable {
    let title: String
    let cover: String
    let categoryName: String?
    let playlistId: String
    
    enum CodingKeys: String, CodingKey {
        case title, cover
        case categoryName = "category_name"
        case playlistId = "playlist_id"
    }
}

struct SearchSubliminalResponse: Decodable {
    let title: String
    let cover: String
    let categoryName: String?
    let subliminalId: String
    
    enum CodingKeys: String, CodingKey {
        case title, cover
        case categoryName = "category_name"
        case subliminalId = "subliminal_id"
    }
}

struct SearchPlaylistAndSubliminalErrorResponse: Decodable {
    let message: String
}
