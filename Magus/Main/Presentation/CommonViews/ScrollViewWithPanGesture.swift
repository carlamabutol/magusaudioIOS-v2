//
//  ScrollViewWithPanGesture.swift
//  Magus
//
//  Created by Jomz on 9/2/23.
//

import UIKit

class ScrollViewWithPanGesture: UIScrollView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
