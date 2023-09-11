//
//  FeaturedPlaylist.swift
//  Magus
//
//  Created by Jomz on 7/1/23.
//

import Foundation

struct FeaturedPlaylistResponse: EndpointResponse {
    typealias ErrorResponse = FeaturedPlaylistErrorResponse
    
    let playlist: [SearchPlaylistResponse]
}

struct FeaturedPlaylistErrorResponse: Decodable {
    let message: String
}


