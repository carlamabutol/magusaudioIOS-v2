//
//  IPO.swift
//  Magus
//
//  Created by Jomz on 12/5/23.
//

import Foundation

struct IPO {
    
    let title: String
    let image: String
    let description: String
    
}

extension IPO {
    
    init(ipoResponse: IPOResponse) {
        title       = ipoResponse.title
        image       = ipoResponse.image
        description = ipoResponse.description
    }
    
}
