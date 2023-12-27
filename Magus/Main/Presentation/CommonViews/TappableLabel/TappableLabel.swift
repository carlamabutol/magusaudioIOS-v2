//
//  TappableLabel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/20/23.
//

import UIKit

class TappableLabel: UILabel {
    typealias TappableTextHandler = (() -> Void)
    
    var tappableRange: NSRange?
    var tappableHandler: TappableTextHandler?
    var nonTappablelHandler: TappableTextHandler?
    var tappableAttrb: NSAttributedString?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let tappableRange = tappableRange, let touch = touches.first {
            let location = touch.location(in: self)
            if NSLocationInRange(locationToIndex(location), tappableRange) {
                // Handle the tap within the specified range
                // TODO: Change Color if necessarry
                let abc = attributedText?.attributedSubstring(from: tappableRange)
                tappableAttrb = abc
                tappableHandler?()
            } else {
                nonTappablelHandler?()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let tappableRange = tappableRange, let touch = touches.first {
            let location = touch.location(in: self)
            if !NSLocationInRange(locationToIndex(location), tappableRange) {
                // TODO: Remove changed color
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // TODO: Remove changed color
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = .clear
    }

    private func locationToIndex(_ location: CGPoint) -> Int {
        let textStorage = NSTextStorage(attributedString: attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
