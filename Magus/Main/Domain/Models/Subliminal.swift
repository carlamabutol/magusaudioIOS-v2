//
//  Subliminal.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct Subliminal {
    
    let id: Int
    let subliminalID, title: String
    let cover: String
    let description: String?
    let isFeatured, isVisible: Int?
    let subscriptionID: String
    let guide, moodsID: String?
    let info: [SubliminalAudioInfo]
    
}

extension Subliminal {
    
    init(subliminalReponse: SubliminalResponse) {
        id = subliminalReponse.id
        subliminalID = subliminalReponse.subliminalID
        title = subliminalReponse.title
        cover = subliminalReponse.cover
        description = subliminalReponse.description
        isFeatured = subliminalReponse.isFeatured
        isVisible = subliminalReponse.isVisible
        subscriptionID = subliminalReponse.subscriptionID
        guide = subliminalReponse.guide
        moodsID = subliminalReponse.moodsID
        info = subliminalReponse.info.map { SubliminalAudioInfo(infoResponse: $0) }
        
    }
    
    init(playlistSubliminalResponse: PlaylistSubliminalResponse) {
        id = playlistSubliminalResponse.id
        subliminalID = playlistSubliminalResponse.subliminalID
        title = playlistSubliminalResponse.title
        cover = playlistSubliminalResponse.cover
        description = playlistSubliminalResponse.description
        isFeatured = playlistSubliminalResponse.isFeatured
        isVisible = playlistSubliminalResponse.isVisible
        subscriptionID = playlistSubliminalResponse.subscriptionID
        guide = playlistSubliminalResponse.guide
        moodsID = playlistSubliminalResponse.moodsID
        info = playlistSubliminalResponse.trackInfo.map { SubliminalAudioInfo(infoResponse: $0) }
        
    }
    
    init(searchSubliminalResponse: SearchSubliminalResponse) {
        id = searchSubliminalResponse.id
        subliminalID = searchSubliminalResponse.subliminalID
        title = ""
        cover = ""
        description = ""
        isFeatured = nil
        isVisible = nil
        subscriptionID = searchSubliminalResponse.subscriptionID
        guide = ""
        moodsID = searchSubliminalResponse.moodsID
        info = []
        
    }
    
}
