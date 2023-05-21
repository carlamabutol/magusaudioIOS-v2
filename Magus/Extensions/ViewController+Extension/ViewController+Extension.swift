//
//  ViewController+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import UIKit

extension UIViewController {
    
    @discardableResult
    func presentAlert(title: String = "", message: String? = nil) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default))
        
        return alertVC
    }
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
