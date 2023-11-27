//
//  UIView+Anchor.swift
//  Magus
//
//  Created by Jomz on 11/25/23.
//

import UIKit

extension UIView {
    
    // MARK: - Add Layout Anchors to SuperView
    public func fillSuperview() {
        if let superview = superview {
//            if #available(iOS 11.0, *) {
//                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true
//                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor).isActive = true
//                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
//                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
//            } else {
                // Fallback on earlier versions
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
                topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
//            }
        }
    }
    
    public func fillView(fromView: UIView, useSafeAreaLayoutGuide: Bool = false, constant: CGFloat = 0) {
        if #available(iOS 11.0, *), useSafeAreaLayoutGuide {
            leadingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
            trailingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.trailingAnchor, constant: -constant).isActive = true
            topAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        } else {
            leadingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: constant).isActive = true
            trailingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: -constant).isActive = true
            topAnchor.constraint(equalTo: fromView.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: fromView.bottomAnchor, constant: -constant).isActive = true
        }
    }
    
    // MARK: - Add "self.view" Leading Anchor to FromView
    public func addLeadingConstraint(fromView: UIView, useSafeAreaLayoutGuide: Bool = false, layoutAnchor: XLayoutAnchor = .leading, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if #available(iOS 11.0, *), useSafeAreaLayoutGuide {
            constraint = leadingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            if layoutAnchor == .trailing {
                constraint = leadingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            }
        } else {
            constraint = leadingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: constant)
            if layoutAnchor == .trailing {
                constraint = leadingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: constant)
            }
        }
        constraint.isActive = isActive
        return constraint
    }
    
    // MARK: - Add "self.view" Trailing Anchor to FromView
    public func addTrailingConstraint(fromView: UIView, useSafeAreaLayoutGuide: Bool = false, layoutAnchor: XLayoutAnchor = .trailing, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if #available(iOS 11.0, *), useSafeAreaLayoutGuide {
            constraint = trailingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.trailingAnchor, constant: constant)
            if layoutAnchor == .leading {
                constraint = trailingAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            }
        } else {
            constraint = trailingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: constant)
            if layoutAnchor == .leading {
                constraint = trailingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: constant)
            }
        }
        constraint.isActive = isActive
        return constraint
    }
    
    // MARK: - Add "self.view" Top Anchor to FromView
    public func addTopConstraint(fromView: UIView, useSafeAreaLayoutGuide: Bool = false, layoutAnchor: YLayoutAnchor = .top, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if #available(iOS 11.0, *), useSafeAreaLayoutGuide {
            constraint = topAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.topAnchor, constant: constant)
            if layoutAnchor == .bottom {
                constraint = topAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.bottomAnchor, constant: constant)
            }
        } else {
            constraint = topAnchor.constraint(equalTo: fromView.topAnchor, constant: constant)
            if layoutAnchor == .bottom {
                constraint = topAnchor.constraint(equalTo: fromView.bottomAnchor, constant: constant)
            }
        }
        constraint.isActive = isActive
        return constraint
    }
    
    // MARK: - Add "self.view" Bottom Anchor to FromView
    public func addBottomConstraint(fromView: UIView, useSafeAreaLayoutGuide: Bool = false, layoutAnchor: YLayoutAnchor = .bottom, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if #available(iOS 11.0, *), useSafeAreaLayoutGuide {
            constraint = bottomAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.bottomAnchor, constant: constant)
            if layoutAnchor == .top {
                constraint = bottomAnchor.constraint(equalTo: fromView.safeAreaLayoutGuide.topAnchor, constant: constant)
            }
        } else {
            constraint = bottomAnchor.constraint(equalTo: fromView.bottomAnchor, constant: constant)
            if layoutAnchor == .top {
                constraint = bottomAnchor.constraint(equalTo: fromView.topAnchor, constant: constant)
            }
        }
        constraint.isActive = isActive
        return constraint
    }
    
    public func addCenterXConstraint(fromView: UIView, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        constraint = centerXAnchor.constraint(equalTo: fromView.centerXAnchor, constant: constant)
        constraint.isActive = isActive
        return constraint
    }
    
    public func addCenterYConstraint(fromView: UIView, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        constraint = centerYAnchor.constraint(equalTo: fromView.centerYAnchor, constant: constant)
        constraint.isActive = isActive
        return constraint
    }
    
    public func addHeightConstraint(fromView: UIView? = nil, constant: CGFloat = 0, multiplier: CGFloat = 1, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        guard let fromView = fromView else {
            constraint = heightAnchor.constraint(equalToConstant: constant)
            constraint.isActive = isActive
            return constraint
        }
        constraint = heightAnchor.constraint(equalTo: fromView.heightAnchor, multiplier: multiplier, constant: constant)
        
        constraint.isActive = isActive
        return constraint
    }
    
    public func addWidthConstraint(fromView: UIView? = nil, constant: CGFloat = 0, multiplier: CGFloat = 1, isActive: Bool = true) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        guard let fromView = fromView else {
            constraint = widthAnchor.constraint(equalToConstant: constant)
            constraint.isActive = isActive
            return constraint
        }
        constraint = widthAnchor.constraint(equalTo: fromView.widthAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = isActive
        return constraint
    }
    
    /// Returns the first constraint with the given identifier, if available.
    ///
    /// - Parameter identifier: The constraint identifier.
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first {
            return $0.identifier == identifier
        }
    }
    
    public enum LayoutAnchor {
        case top
        case leading
        case trailing
        case bottom
    }

    public enum YLayoutAnchor {
        case top
        case bottom
    }

    public enum XLayoutAnchor {
        case leading
        case trailing
    }

}
