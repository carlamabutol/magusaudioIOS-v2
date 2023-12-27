//
//  Helper.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import Foundation

typealias CompletionHandler = () -> Void

class Helper {
    static let shared = Helper()
    
    static func checkTimeOfDay() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        if (6..<12).contains(hour) {
            return "Good morning!"
        } else if (18..<24).contains(hour) {
            return "Good evening!"
        } else {
            return "Good day!"
        }
    }
    
    func containsSpecialCharacter(text: String) -> Bool {
        text.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil
    }
    
    func containsNumberCharacter(text: String) -> Bool {
        text.range(of: ".*[0-9].*", options: .regularExpression) != nil
    }
    
    func containsUppercaseCharacter(text: String) -> Bool {
        text.range(of: ".*[A-Z].*", options: .regularExpression) != nil
    }
    
    func containsLowercaseCharacter(text: String) -> Bool {
        text.range(of: ".*[a-z].*", options: .regularExpression) != nil
    }

}
