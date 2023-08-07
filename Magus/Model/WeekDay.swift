//
//  Weekday.swift
//  Magus
//
//  Created by Jomz on 8/3/23.
//

import Foundation

struct WeekDay: Identifiable, Hashable {
    // 1
    let id = UUID()
    var startDate: Date!
    var endDate: Date!
    var dates: [Date] = []
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: WeekDay, rhs: WeekDay) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WeekDay {
    
    var displayText: String {
        let startDay = startDate.getDateFormat(with: "d")
        let startMonth = startDate.getDateFormat(with: "MMM")
        let endDay = endDate.getDateFormat(with: "d")
        let endMonth = endDate.getDateFormat(with: "MMM")
        if startMonth == endMonth {
            return startDay + " - " + endDay + " " + endMonth
        }
        return "\(startDay) \(startMonth) - \(endDay) \(endMonth)"
    }
}

