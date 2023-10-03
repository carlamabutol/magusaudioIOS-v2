//
//  ChangePasswordViewController.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import UIKit

class ChangePasswordViewController: CommonViewController {
    
    private let viewModel = ChangePasswordViewModel()
    
    @IBOutlet var navigationBar: ProfileNavigationBar!
    
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            let accountPrivacyAttrb = NSAttributedString(string: "\(LocalizedStrings.EditProfile.accountPrivacy.uppercased()) >", attributes: [.font: UIFont.Montserrat.bold12])
            let changePassAttrb = NSAttributedString(string: " " + LocalizedStrings.EditProfile.changePassword.uppercased(), attributes: [.font: UIFont.Montserrat.bold17])
            let attrbString = NSMutableAttributedString(attributedString: accountPrivacyAttrb)
            attrbString.append(changePassAttrb)
            titleLbl.numberOfLines = 2
            titleLbl.attributedText = attrbString
        }
    }
    
    @IBOutlet var currentPasswordForm: FormTextFieldView! {
        didSet {
            currentPasswordForm.backgroundColor = .white
            currentPasswordForm.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var newPasswordForm: FormTextFieldView!{
        didSet {
            newPasswordForm.backgroundColor = .white
            newPasswordForm.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var confirmNewPasswordForm: FormTextFieldView!{
        didSet {
            confirmNewPasswordForm.backgroundColor = .white
            confirmNewPasswordForm.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var requirementsStackView: UIStackView!
    
    @IBOutlet var requirementsTitleLbl: UILabel! {
        didSet {
            requirementsTitleLbl.font = .Montserrat.semibold1
            requirementsTitleLbl.text = LocalizedStrings.ChangePassword.passwordMust
            requirementsTitleLbl.textColor = .TextColor.primaryBlack.withAlphaComponent(0.56)
        }
    }
    
    @IBOutlet var firstPasswordReqView: PasswordRequirementView! {
        didSet {
            firstPasswordReqView.configure(text: LocalizedStrings.ChangePassword.contain8Characters)
        }
    }
    
    @IBOutlet var secondPasswordReqView: PasswordRequirementView! {
        didSet {
            secondPasswordReqView.configure(text: LocalizedStrings.ChangePassword.includeOneUppercase)
        }
    }
    
    @IBOutlet var thirdPasswordReqView: PasswordRequirementView! {
        didSet {
            thirdPasswordReqView.configure(text: LocalizedStrings.ChangePassword.includeOneNumber)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.configure(
            model: .init(
                leftButtonHandler: {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonHandler: { [weak self] in
                    self?.presentDefaultAlert()
                }, rightButtonModel: .init(title: "Save", image: nil)
            )
        )
        configureForms()
    }
    
    private func configureForms() {
        currentPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.currentPassword,
                         textRelay: viewModel.currentPasswordRelay,
                         isSecureEntry: true)
        )
        newPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.enterNewPassword,
                         textRelay: viewModel.enterNewPasswordRelay,
                         isSecureEntry: true)
        )
        confirmNewPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.confirmPassword,
                         textRelay: viewModel.confirmNewPasswordRelay,
                         isSecureEntry: true)
        )
    }
    
    private func presentDefaultAlert() {
        let alertVC = DefaultAlertViewController.instantiate(from: .defaultAlert) as! DefaultAlertViewController
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
        alertVC.configure(.init(title: "", message: "Are you sure you want to change your password?", actionHandler: { [weak self] in
            self?.dismiss(animated: true)
        }))
    }
}
