//
//  Day.swift
//  Magus
//
//  Created by Jomz on 8/3/23.
//

import Foundation

struct Day: Identifiable, Equatable {
    // 1
    let id = UUID()
    let date: Date
    //  // 2
    //  let number: String
    //  // 3
    //  let isSelected: Bool
    //  // 4
    //  let isWithinDisplayedMonth: Bool
}

extension Day {
    
    var dateStringFormatted: String {
        return date.getDateFormat(with: "YYYY-MM-dd")
    }
    
    var dayString: String {
        return date.dayToday(with: "d")
    }
    
    var monthString: String {
        return date.getDateFormat(with: "MMM")
    }
    
    var hasMonthString: Bool {
        let day = date.dayToday(with: "d")
        if day == "1" {
            return true
        }
        return false
    }
    
    var dateString: String {
        let day = date.dayToday(with: "d")
        if day == "1" {
            let month = date.dayToday(with: "MMM")
            return "\(month)\n\(day)"
        }
        return day
    }
    
    
    var unixTime: TimeInterval {
        let dateFormat = "MM/dd/yyyy HH:mm:ss"
        let format = date.getDateFormat(with: dateFormat)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        print("DATE FORMATTER - ", format)
        if let date = dateFormatter.date(from: format) {
            print("DATE FORMATTER - ", date.timeIntervalSince1970.rounded())
            return date.timeIntervalSince1970.rounded()
        }
        return date.timeIntervalSince1970.rounded()
    }
    
    var startUnix: TimeInterval {
        let format = date.getDateFormat(with: "MM/dd/yyyy HH:mm:ss")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        print("DATE FORMATTER - ", format)
        if let date = dateFormatter.date(from: format) {
            print("DATE FORMATTER - ", date.timeIntervalSince1970.rounded())
            return date.timeIntervalSince1970.rounded()
        }
        return date.timeIntervalSince1970.rounded()
    }
    
    var endUnix: TimeInterval {
        let format = date.getDateFormat(with: "MM/dd/yyyy")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        print("DATE FORMATTER - ", format)
        if let date = dateFormatter.date(from: format + "23:59:59") {
            print("DATE FORMATTER - ", date.timeIntervalSince1970)
            return date.timeIntervalSince1970
        }
        return date.timeIntervalSince1970
    }
}


