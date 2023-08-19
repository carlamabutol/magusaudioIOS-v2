//
//  SubliminalInfo.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import Foundation

struct SubliminalInfo {
    
    let id: Int
    let subliminalID, trackID: String
    let version, audioTypeID, volume: Int
    let trackTitle, link: String?
    
}

extension SubliminalInfo {
    
    init(infoResponse: SubliminalInfoResponse) {
        id = infoResponse.id
        subliminalID = infoResponse.subliminalID
        trackID = infoResponse.trackID
        version = infoResponse.version
        audioTypeID = infoResponse.audioTypeID
        volume = infoResponse.volume
        trackTitle = infoResponse.trackTitle
        link = infoResponse.link
    }
    
}
