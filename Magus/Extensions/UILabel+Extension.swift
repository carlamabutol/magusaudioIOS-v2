//
//  UILabel+Extension.swift
//  Magus
//
//  Created by Jomz on 9/29/23.
//

import UIKit

extension UILabel {
    
    func setTextWithShadow(text: String) {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [NSAttributedString.Key.shadow: myShadow,
                           NSAttributedString.Key.font: self.font,
                           NSAttributedString.Key.foregroundColor: UIColor.white]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute as [NSAttributedString.Key : Any])
        attributedText = myAttrString
    }
}
