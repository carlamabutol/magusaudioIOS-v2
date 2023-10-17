//
//  String+extensions.swift
//  Magus
//
//  Created by Jomz on 9/5/23.
//

import Foundation

extension String {
    
    func containsUppercaseLetter() -> Bool {
        let pattern = "[A-Z]"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: self.utf16.count)
            
            // Check if there is at least one match
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            // Handle regex pattern compilation errors
            print("Error: \(error)")
            return false
        }
    }
    
    func lessThan8Characters() -> Bool {
        self.count < 8
    }
    
}
