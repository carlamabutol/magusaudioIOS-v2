//
//  DeleteAccountViewController.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import UIKit
import RxSwift

class DeleteAccountViewController: CommonViewController {
    
    @IBOutlet var profileNavigationBar: ProfileNavigationBar! {
        didSet {
            profileNavigationBar.backgroundColor = .clear
            profileNavigationBar.hideShowButton(isHidden: true)
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 3
            titleLabel.font = .Montserrat.bold17
            titleLabel.text = "Enter your password to delete your Magus Account"
        }
    }
    
    @IBOutlet var currentPasswordView: FormTextFieldView!
    
    @IBOutlet var confirmButton: FormButton! {
        didSet {
            let titleAttributed = NSAttributedString(string: "Confirm", attributes: [.font: UIFont.Montserrat.bold15, .foregroundColor: UIColor.TextColor.primaryBlue])
            confirmButton.setAttributedTitle(titleAttributed, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordView.configure(model: .init(placeholder: "Current Password", textRelay: .init(value: "")))
    }
    
    override func setupBinding() {
        super.setupBinding()
        confirmButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentDefaultAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentDefaultAlert() {
        let alertVC = DefaultAlertViewController.instantiate(from: .defaultAlert) as! DefaultAlertViewController
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
        alertVC.configure(.init(title: "", message: "Are you sure you want to delete your account?", actionHandler: { [weak self] in
            self?.dismiss(animated: true)
        }))
    }
}
