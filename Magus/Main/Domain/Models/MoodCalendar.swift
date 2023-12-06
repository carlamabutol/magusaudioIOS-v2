//
//  MoodCalendar.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation

struct MoodCalendar {
    let monthly, weekly: [Monthly]
}

// MARK: - Monthly
struct Monthly {
    let date: String
    let id: Int?
    let day: String
    let mood: Mood?
}

extension MoodCalendar {
    init(moodCalendar: MoodCalendarResponse) {
        monthly = moodCalendar.monthly.map {
            Monthly(date: $0.day,
                    id: $0.id,
                    day: $0.day,
                    mood: $0.mood.first.map { Mood(moodResponse: $0)})
        }
        weekly = moodCalendar.weekly.map {
            Monthly(date: $0.day,
                    id: $0.id,
                    day: $0.day,
                    mood: $0.mood.first.map { Mood(moodResponse: $0)})
        }
    }
}
