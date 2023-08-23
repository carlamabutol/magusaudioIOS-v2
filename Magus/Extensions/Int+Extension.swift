//
//  Int+Extension.swift
//  Magus
//
//  Created by Jomz on 8/23/23.
//

import Foundation

extension TimeInterval {
    
    func toMinuteAndSeconds() -> String {
        guard !self.isNaN else { return "00:00" }
        let totalMilliseconds = Int(self * 1000) // Convert to milliseconds
        let minutes = totalMilliseconds / 60000 // There are 60,000 milliseconds in a minute
        let seconds = (totalMilliseconds % 60000) / 1000
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
