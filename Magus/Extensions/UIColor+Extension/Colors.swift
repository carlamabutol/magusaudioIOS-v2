//
//  UIColor+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import UIKit

extension UIColor {
    
    enum Background {
        static let primary = UIColor(rgb: 0xF4FAFF)
        static let moodBackgroundColor = UIColor(rgb: 0xEAEAEA)
    }
    
    enum TextColor {
        static let primaryBlack = UIColor(rgb: 0x2F3033)
        static let primaryBlue = UIColor(rgb: 0x427AB3)
        static let placeholderColor = UIColor(rgb: 0x69696978).withAlphaComponent(0.47)
    }
    
    enum BorderColor {
        static let formColor = UIColor(rgb: 0xCECECE)
    }
    
    enum ButtonColor {
        static let primaryBlue = UIColor(rgb: 0x427AB3)
    }
    
    enum TabItemTitleColor {
        static let primaryColor = UIColor(rgb: 0x427AB3)
    }
}
