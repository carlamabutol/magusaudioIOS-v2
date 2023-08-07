//
//  Date+Extension.swift
//  Magus
//
//  Created by Jomz on 8/3/23.
//

import Foundation

extension Date {
    
    enum WeekDayEnum: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    func getWeekDay() -> WeekDayEnum {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDayEnum(rawValue: weekDay)!
    }
}

extension Date {
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    var dateStringFormatted: String {
        return self.getDateFormat(with: "YYYY-MM-dd")
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func dateToday(with format: String = "MM/dd/YYYY", timeZone: TimeZone? = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dayToday(with format: String = "EEEE", timeZone: TimeZone? = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeToday(with format: String = "HH:mm", timeZone: TimeZone? = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeTodayAMPM(with format: String = "hh:mm a", timeZone: TimeZone? = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        let time = timeToday(with: format, timeZone: timeZone)
        if let dateTime = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: dateTime)
        }
        return time
    }
    
    func yearToday(with format: String = "YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateFormat(with format: String = "YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

