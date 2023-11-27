//
//  Subliminal.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct Subliminal: Codable, Equatable, Hashable {
    
    let id: Int
    let subliminalID, title: String
    let playlistId: String?
    let cover: String
    let description: String?
    var isFeatured, isVisible, isLiked: Int?
    let subscriptionID: String
    let guide, moodsID: String?
    let info: [SubliminalAudioInfo]
    
}

extension Subliminal {
    
    init(subliminalReponse: SubliminalResponse) {
        id = subliminalReponse.id
        subliminalID = subliminalReponse.subliminalID
        playlistId = subliminalReponse.playlistId
        title = subliminalReponse.title ?? ""
        cover = subliminalReponse.cover
        description = subliminalReponse.description
        isFeatured = subliminalReponse.isFeatured
        isVisible = subliminalReponse.isVisible
        isLiked = subliminalReponse.isLiked
        subscriptionID = subliminalReponse.subscriptionID ?? ""
        guide = subliminalReponse.guide
        moodsID = subliminalReponse.moodsID
        info = subliminalReponse.tracks?.map { SubliminalAudioInfo(infoResponse: $0) } ?? []
        
    }
    
    init(playlistSubliminalResponse: PlaylistSubliminalResponse) {
        id = playlistSubliminalResponse.id
        subliminalID = playlistSubliminalResponse.subliminalID
        playlistId = playlistSubliminalResponse.playlistId
        title = playlistSubliminalResponse.title ?? ""
        cover = playlistSubliminalResponse.cover
        description = playlistSubliminalResponse.description
        isFeatured = playlistSubliminalResponse.isFeatured
        isVisible = playlistSubliminalResponse.isVisible
        isLiked = playlistSubliminalResponse.isLiked
        subscriptionID = playlistSubliminalResponse.subscriptionID ?? ""
        guide = playlistSubliminalResponse.guide
        moodsID = playlistSubliminalResponse.moodsID
        info = playlistSubliminalResponse.trackInfo.map { SubliminalAudioInfo(infoResponse: $0) }
        
    }
    
    init(searchSubliminalResponse: SearchSubliminalResponse) {
        id = searchSubliminalResponse.id
        subliminalID = searchSubliminalResponse.subliminalID
        playlistId = searchSubliminalResponse.playlistID
        title = ""
        cover = ""
        description = ""
        isFeatured = nil
        isVisible = nil
        isLiked = searchSubliminalResponse.isLiked
        subscriptionID = searchSubliminalResponse.subscriptionID
        guide = ""
        moodsID = searchSubliminalResponse.moodsID
        info = []
        
    }
    
}
