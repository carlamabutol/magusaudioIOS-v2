//
//  Playlist.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct Playlist: Equatable {
    
    let id: Int
    let title: String
    let cover: String
    let playlistID: String
    let description: String?
    var isVisible: Int
    let subscriptionID, userID: String?
    var isFeatured: Int
    let moodsID: String?
    let categoryID, isOwnPlaylist: Int?
    var isLiked: Int?
    let categoryName: String
    var subliminals: [Subliminal]
    
}

extension Playlist {
    
    init(searchPlaylistResponse: SearchPlaylistResponse) {
        id = searchPlaylistResponse.id
        title = searchPlaylistResponse.title
        cover = searchPlaylistResponse.cover
        playlistID = searchPlaylistResponse.playlistID 
        description = searchPlaylistResponse.description
        isVisible = searchPlaylistResponse.isVisible
        subscriptionID = searchPlaylistResponse.subscriptionID
        userID = searchPlaylistResponse.userID
        isFeatured = searchPlaylistResponse.isFeatured
        moodsID = searchPlaylistResponse.moodsID
        categoryID = searchPlaylistResponse.categoryID
        isOwnPlaylist = searchPlaylistResponse.isOwnPlaylist
        isLiked = searchPlaylistResponse.isLiked
        categoryName = searchPlaylistResponse.categoryName
        subliminals = searchPlaylistResponse.subliminals.map{ Subliminal(subliminalReponse: $0) }
    }
    
}
