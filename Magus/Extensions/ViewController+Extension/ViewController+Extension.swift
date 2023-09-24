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
    
    func presentModally(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: animated)
    }
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getSafeAreaLayoutGuide() -> (CGFloat, CGFloat) {
//        if #available(iOS 15.0, *) {
//            let window = UIApplication.shared.currentScene?.keyWindow
//            let topPadding = window.safeAreaInsets.top
//            let bottomPadding = window.safeAreaInsets.bottom
//            return (topPadding, bottomPadding)
//        }
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return (topPadding, bottomPadding)
    }
    
    func setupGradientView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.Background.primary.cgColor]
        gradientLayer.startPoint = .init(x: 1.0, y: 0.1)
        gradientLayer.endPoint = .init(x: 1.0, y: 0.2)
        
        // Set the frame to the layer
        gradientLayer.frame = view.bounds
        view.backgroundColor = .clear
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.applyShadow(color: UIColor.white.withAlphaComponent(0.5), shadowOpacity: 0.2)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
