//
//  CalendarMonth.swift
//  Magus
//
//  Created by Jomz on 8/3/23.
//

import Foundation

struct CalendarMonth: Identifiable, Hashable {
    let id = UUID().uuidString
    let month: Date
    var days: [Day]
    var monthDays: [WeekDay] = []
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: CalendarMonth, rhs: CalendarMonth) -> Bool {
        return lhs.id == rhs.id && lhs.month == rhs.month && lhs.days == rhs.days && lhs.monthDays == rhs.monthDays 
    }
}

extension CalendarMonth {
    var monthString: String {
        return month.getDateFormat(with: "MMM")
    }
    var fullMonthString: String {
        return month.getDateFormat(with: "MMMM YYYY")
    }
    
    var picID: Int {
        let component = Calendar.current.dateComponents([.month, .year], from: month)
        return component.month! + component.year! - 2000
    }
}
