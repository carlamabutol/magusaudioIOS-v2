//
//  UIView+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) { frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue) { frame.origin.y = newValue }
    }
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) { frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue) { frame.size.height = newValue }
    }
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for view in subviews {
            if view.firstResponder != nil {
                return view.firstResponder
            }
        }
        return nil
    }
    
    func dismissKeyboard() {
        firstResponder?.resignFirstResponder()
    }
    
    func cornerRadius(with cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func cornerBorderRadius(cornerRadius: CGFloat,
                            borderColor: UIColor,
                            borderWidth: CGFloat = 1) {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    func applyShadow(scale: Bool = true, color: UIColor = .black, radius: CGFloat, shadowOpacity: Float = 0.2, offset: CGSize = .init(width: 0, height: 2)) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
