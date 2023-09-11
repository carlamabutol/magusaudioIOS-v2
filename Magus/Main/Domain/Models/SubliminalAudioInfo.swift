//
//  SubliminalInfo.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct SubliminalAudioInfo: Codable, Hashable {
    
    let id: Int
    let subliminalID, trackID: String
    let version, audioTypeID, volume: Int
    let duration: Int
    let trackTitle, link: String?
    
}

extension SubliminalAudioInfo {
    
    init(infoResponse: SubliminalInfoResponse) {
        id = infoResponse.id
        subliminalID = infoResponse.subliminalID
        trackID = infoResponse.trackID
        version = infoResponse.version
        audioTypeID = infoResponse.audioTypeID
        volume = infoResponse.volume
        trackTitle = infoResponse.title
        link = infoResponse.link
        duration = infoResponse.duration
    }
    
}
