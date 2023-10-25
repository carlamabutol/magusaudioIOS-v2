//
//  FeaturedPlaylist.swift
//  Magus
//
//  Created by Jomz on 7/1/23.
//

import Foundation

struct FeaturedResponse: EndpointResponse {
    typealias ErrorResponse = FeaturedErrorResponse
    
    let playlist: [SearchPlaylistResponse]
    let subliminal: [SubliminalResponse]
}

struct FeaturedErrorResponse: Decodable {
    let message: String
}


