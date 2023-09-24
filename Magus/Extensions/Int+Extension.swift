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

extension Int {
    
    func toMinuteAndSeconds() -> String {
        let totalMilliseconds = self // Convert to milliseconds
        let minutes = totalMilliseconds / 60000 // There are 60,000 milliseconds in a minute
        let seconds = (totalMilliseconds % 60000) / 1000
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toString() -> String {
        String(describing: self)
    }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }()
    
    var commaRepresentation: String {
        return Float.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension FloatingPoint {
    var isInteger: Bool { rounded() == self}
}


