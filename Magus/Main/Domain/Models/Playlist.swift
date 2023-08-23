//
//  Playlist.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct Playlist {
    
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
    let name, image: String
    let info: [Subliminal]
    
}

extension Playlist {
    
    init(playlistResponse: FeaturedPlaylistResponse) {
        id = playlistResponse.id
        title = playlistResponse.title
        cover = playlistResponse.cover
        playlistID = playlistResponse.playlistID
        description = playlistResponse.description
        isVisible = playlistResponse.isVisible
        subscriptionID = playlistResponse.subscriptionID
        userID = playlistResponse.userID
        isFeatured = playlistResponse.isFeatured
        moodsID = playlistResponse.moodsID
        categoryID = playlistResponse.categoryID
        isOwnPlaylist = playlistResponse.isOwnPlaylist
        isLiked = playlistResponse.isLiked
        name = playlistResponse.name ?? ""
        image = playlistResponse.image ?? ""
        info = playlistResponse.info.map{ Subliminal(playlistSubliminalResponse: $0) }
    }
    
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
        name = searchPlaylistResponse.name ?? ""
        image = searchPlaylistResponse.image ?? ""
        info = searchPlaylistResponse.info.map{ Subliminal(searchSubliminalResponse: $0) }
    }
    
}
