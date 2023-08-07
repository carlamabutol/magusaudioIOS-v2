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
        }
    }
    
    @IBOutlet var newPasswordForm: FormTextFieldView!{
        didSet {
            newPasswordForm.backgroundColor = .white
        }
    }
    
    @IBOutlet var confirmNewPasswordForm: FormTextFieldView!{
        didSet {
            confirmNewPasswordForm.backgroundColor = .white
        }
    }
    
    @IBOutlet var requirementsStackView: UIStackView!
    
    @IBOutlet var requirementsTitleLbl: UILabel! {
        didSet {
            requirementsTitleLbl.font = .Montserrat.semibold1
            requirementsTitleLbl.text = LocalizedStrings.EditProfile.passwordMust
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.configure { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        } saveHandler: { [weak self] in
            // TODO SAVE
            self?.dismiss(animated: true)
        }
        configureForms()
    }
    
    private func configureForms() {
        currentPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.currentPassword,
                         textObservable: viewModel.currentPasswordRelay)
        )
        newPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.enterNewPassword,
                         textObservable: viewModel.enterNewPasswordRelay)
        )
        confirmNewPasswordForm.configure(
            model: .init(placeholder: LocalizedStrings.EditProfile.confirmPassword,
                         textObservable: viewModel.confirmNewPasswordRelay)
        )
    }
}
