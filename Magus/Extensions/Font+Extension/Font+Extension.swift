//
//  Font+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import UIKit

extension UIFont {
    
    // FONT WEIGHT = 400
    private static func montSerratRegular(with size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    // FONT WEIGHT = 500
    private static func montSerratMedium(with size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Medium", size: size)!
    }
    
    // FONT WEIGHT = 600
    private static func montSerratSemiBold(with size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    // FONT WEIGHT = 700
    private static func montSerratBold(with size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    struct Montserrat {
        
        // Regular
        static let body1 = UIFont.montSerratRegular(with: 13)
        static let body2 = UIFont.montSerratRegular(with: 10)
        static let body3 = UIFont.montSerratRegular(with: 15)
        
        // Medium
        static let medium1 = UIFont.montSerratSemiBold(with: 13)
        static let medium2 = UIFont.montSerratSemiBold(with: 15)
        
        // SemiBold
        static let semibold1 = UIFont.montSerratSemiBold(with: 13)
        
        // Bold
        static let bold1 = UIFont.montSerratBold(with: 16)
        static let bold2 = UIFont.montSerratBold(with: 13)
        static let bold3 = UIFont.montSerratBold(with: 10)
        
        // title
        static let title = UIFont.montSerratBold(with: 35)
        static let title1 = UIFont.montSerratBold(with: 25)
        static let title2 = UIFont.montSerratBold(with: 20)
        
    }
    
}
