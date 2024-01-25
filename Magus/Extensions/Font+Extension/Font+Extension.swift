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
        static let body4 = UIFont.montSerratRegular(with: 14)
        
        // Medium
        static let medium1 = UIFont.montSerratSemiBold(with: 13)
        static let medium2 = UIFont.montSerratSemiBold(with: 15)
        static let medium17 = UIFont.montSerratSemiBold(with: 17)
        static let medium20 = UIFont.montSerratSemiBold(with: 20)
        static let medium10 = UIFont.montSerratSemiBold(with: 10)
        static let medium7 = UIFont.montSerratSemiBold(with: 7)
        
        // SemiBold
        static let semibold1 = UIFont.montSerratSemiBold(with: 13)
        static let semibold15 = UIFont.montSerratSemiBold(with: 15)
        static let semibold17 = UIFont.montSerratSemiBold(with: 17)
        static let semibold24 = UIFont.montSerratSemiBold(with: 24)
        static let semibold30 = UIFont.montSerratSemiBold(with: 30)
        
        // Bold
        static let bold1 = UIFont.montSerratBold(with: 16)
        static let bold2 = UIFont.montSerratBold(with: 13)
        static let bold3 = UIFont.montSerratBold(with: 10)
        static let bold17 = UIFont.montSerratBold(with: 17)
        static let bold15 = UIFont.montSerratBold(with: 15)
        static let bold12 = UIFont.montSerratBold(with: 15)
        
        // title
        static let title = UIFont.montSerratBold(with: 35)
        static let title1 = UIFont.montSerratBold(with: 25)
        static let title2 = UIFont.montSerratBold(with: 20)
        static let title3 = UIFont.montSerratBold(with: 30)
        
    }
    
}
