//
//  KeyboardManager.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/20/23.
//

import UIKit

protocol KeyboardManager where Self: UIViewController {
    var scrollView: UIScrollView { get }
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
    func registerForKeyboardNotifications()
    
}
                                   
extension KeyboardManager {
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo: [AnyHashable: Any] = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
                NSValue,
              let firstResponder = view.firstResponder, // The text field
              let containerView = firstResponder.superview,
              let windowHeight = view.window?.height
                
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        let padding: CGFloat = 65
        let existingBottomInset = view.frame.height - (scrollView.frame.origin.y +
                                                       scrollView.frame.size.height)
        let containerViewYPositionInWindow =
        containerView.convert(firstResponder.frame.origin, to: nil).y
        let containerViewYPositionDifference = (containerViewYPositionInWindow +
                                               firstResponder.frame.size.height) - (windowHeight - keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = keyboardHeight + padding - existingBottomInset
            
            if containerViewYPositionDifference > 0 {
                self.scrollView.contentOffset.y += containerViewYPositionDifference + padding
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let userinfo: [AnyHashable: Any] = notification.userInfo,
              let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        let padding: CGFloat = 65
        let existingBottomInset = view.frame.height - (scrollView.frame.origin.y + scrollView.frame.size.height)
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom -= keyboardHeight + padding - existingBottomInset
        }
    }
    
}

