//
//  Mood.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import Foundation

struct Mood: Codable, Equatable {
    
    let id: Int
    let name: String
    let status: Mood.Status
    let isVisible: Int?
    let description: String
    let image: String?
    
    var greeting: String {
        switch status {
        case .positive:
            return "Glad that you are feeling \(name) today!"
        case .negative:
            return "We're here to cheer you up!"
        }
    }
    
}

extension Mood {
    
    enum Status: String, Codable {
        case positive = "Positive"
        case negative = "Negative"
    }
    
    init(moodResponse: MoodResponse) {
        id = moodResponse.id
        name = moodResponse.name
        status = Mood.Status(rawValue: moodResponse.status) ?? .positive
        description = moodResponse.description
        image = moodResponse.image
        isVisible = moodResponse.isVisible
    }
    
}
