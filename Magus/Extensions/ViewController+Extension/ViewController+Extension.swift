//
//  ViewController+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String = "", message: String? = nil, tapOKHandler: CompletionHandler? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            tapOKHandler?()
        }))
        
        present(alertVC, animated: true)
    }
    
    func presentModally(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        let rootViewContorller = UIApplication.shared.keyWindow?.rootViewController ?? self
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        rootViewContorller.present(viewController, animated: animated)
    }
    
    @discardableResult
    func presentLoading() -> UIViewController {
        let alertController = UIViewController()
        
        // Create and add an activity indicator to the alert controller
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.startAnimating()
        alertController.view.addSubview(loadingIndicator)
        
        // Center the activity indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor).isActive = true
        presentModally(alertController, animated: true)
        return alertController
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
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension UIViewController {
    
    func setupGradientView(view: UIView) {
        view.layoutIfNeeded()
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
}
