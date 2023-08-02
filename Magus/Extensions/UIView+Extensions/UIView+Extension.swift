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
    
    func circle() {
        layer.cornerRadius = frame.size.height / 2
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
    
    func applyShadow(scale: Bool = true, color: UIColor = .black, radius: CGFloat = 0, shadowOpacity: Float = 0.2, offset: CGSize = .init(width: 3, height: 2)) {
        layer.shadowRadius = radius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
    }
    
    func applyShadowLayer(radius: CGFloat = 5, shadowOpacity: Float = 0.2) {
        let shadowLayer: CAShapeLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowPath = shadowLayer.path
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, shadowRadius: CGFloat = 1, scale: Bool = true, cornerRadius: CGFloat) {
         let shadowLayer = CAShapeLayer()
         shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
         shadowLayer.fillColor = UIColor.white.cgColor
         shadowLayer.shadowColor = color.cgColor
         shadowLayer.shadowPath = shadowLayer.path
         shadowLayer.shadowOffset = offSet
         shadowLayer.shadowOpacity = opacity
         shadowLayer.shadowRadius = shadowRadius
         layer.insertSublayer(shadowLayer, at: 0)
     }
    
}
