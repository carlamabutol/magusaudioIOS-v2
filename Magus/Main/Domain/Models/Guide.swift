//
//  Guide.swift
//  Magus
//
//  Created by Jomz on 12/3/23.
//

import Foundation

struct Guide {
    
    let image: String
    let description: String
    
}

extension Guide {
    
    init(guideResponse: GuideResponse) {
        image = guideResponse.image
        description = guideResponse.description
    }
    
}

