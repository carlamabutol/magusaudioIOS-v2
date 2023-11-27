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
        static let primaryBlue = UIColor(rgb: 0x427AB3)
        static let moodBackgroundColor = UIColor(rgb: 0xEAEAEA)
        static let alertFailBackgroundColor = UIColor(rgb: 0xFDEDEE)
        static let alertSuccessBackgroundColor = UIColor(rgb: 0xF4FAFF)
        static let buttonGray = UIColor(rgb: 0xC6C6C6)
        static let profileAlertBG = UIColor(rgb: 0xEAFBF6)
        static let subscriptionBG = UIColor(rgb: 0xFABA6F)
        static let lightBlue = UIColor(rgb: 0xDDEAF5)
    }
    
    enum TextColor {
        static let primaryBlack = UIColor(rgb: 0x2F3033)
        static let otherBlack1 = UIColor(rgb: 0x272727)
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
