//
//  Category.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import Foundation

struct Category: Codable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let image: String?
}

extension Category {
    
    init(model: CategorySubliminalElement) {
        id = model.id
        name = model.name
        description = model.description
        image = model.image
    }
    
}
