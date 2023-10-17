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

}
