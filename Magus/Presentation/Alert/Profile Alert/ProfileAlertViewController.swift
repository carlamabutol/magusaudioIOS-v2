//
//  ProfileAlert.swift
//  Magus
//
//  Created by Jose Mari Pascual on 8/12/23.
//

import UIKit

class ProfileAlertViewController: CommonViewController {
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .Background.profileAlertBG
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
    
    func configure(alertModel: ProfileAlertViewController.AlertModel) {
        messageLabel.text = alertModel.message
        guard let asset = alertModel.image else { return }
        alertImageView.image = .init(named: asset)
        alertImageView.contentMode = .scaleAspectFit
    }
}

extension ProfileAlertViewController {
    
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
        let image: ImageAsset?
    }
}

