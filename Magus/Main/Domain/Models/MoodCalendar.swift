//
//  MoodCalendar.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation

struct MoodCalendar {
    let date: String
    let mood: String
}

extension MoodCalendar {
    init(moodCalendar: MoodCalendarResponse) {
        date = moodCalendar.date
        mood = moodCalendar.moods
    }
}
