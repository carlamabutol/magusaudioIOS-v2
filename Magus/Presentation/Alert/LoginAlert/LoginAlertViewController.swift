//
//  LoginAlertViewController.swift
//  Magus
//
//  Created by Jomz on 7/18/23.
//

import UIKit
import SDWebImage

class LoginAlertViewController: CommonViewController {
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .Background.alertFailBackgroundColor
        }
    }
    
    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.font = .Montserrat.bold15
            messageLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var alertImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissSelf()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func dismissSelf() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    func configure(alertModel: LoginAlertViewController.AlertModel) {
        messageLabel.text = alertModel.message
        alertImageView.sd_setImage(with: .init(string: alertModel.message))
    }
}

extension LoginAlertViewController {
    
    enum AlertType {
        case failed
        case success
        
        var color: UIColor {
            switch self {
            case .failed:
                return .Background.alertFailBackgroundColor
            case .success:
                return .Background.alertFailBackgroundColor
            }
        }
    }
    
    struct AlertModel {
        let message: String
        let image: String?
    }
}
