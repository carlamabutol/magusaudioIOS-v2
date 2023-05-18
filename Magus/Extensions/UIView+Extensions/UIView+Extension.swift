//
//  UIView+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import UIKit

extension UIView {
    
    func cornerRadius(with cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func dropShadow(scale: Bool = true, radius: CGFloat, offsetY: CGFloat = 2) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: offsetY)
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
