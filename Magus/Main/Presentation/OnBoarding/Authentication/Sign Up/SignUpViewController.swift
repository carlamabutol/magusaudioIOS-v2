//
//  SignUpViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/21/23.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: CommonViewController {
    
    private let viewModel = SignUpViewModel()
    
    @IBOutlet var signUpScrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalisedStrings.SignUp.title
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title
        }
    }
    
    @IBOutlet var descLabel: UILabel! {
        didSet {
            descLabel.text = LocalisedStrings.SignUp.description
            descLabel.font = UIFont.Montserrat.body1
        }
    }
    
    @IBOutlet var fullNameTextFieldView: TextFieldView! {
        didSet {
            fullNameTextFieldView.configure(model: .init(placeholder: LocalisedStrings.Auth.fullName, textRelay: viewModel.fullNameRelay))
        }
    }
    
    @IBOutlet var emailTextFieldView: TextFieldView! {
        didSet {
            emailTextFieldView.configure(model: .init(placeholder: LocalisedStrings.Auth.email, textRelay: viewModel.emailRelay))
        }
    }
    
    @IBOutlet var passwordTextFieldView: TextFieldView! {
        didSet {
            passwordTextFieldView.configure(model: .init(placeholder: LocalisedStrings.Auth.password, textRelay: viewModel.passwordRelay, isSecureEntry: true))
        }
    }
    
    @IBOutlet var confirmPasswordTextFieldView: TextFieldView! {
        didSet {
            confirmPasswordTextFieldView.configure(model: .init(placeholder: LocalisedStrings.Auth.confirmPassword, textRelay: viewModel.confirmPasswordRelay, isSecureEntry: true))
        }
    }
    @IBOutlet var textFieldContainerView: UIView! {
        didSet {
            textFieldContainerView.backgroundColor = .clear
            textFieldContainerView.cornerBorderRadius(cornerRadius: 5, borderColor: UIColor.BorderColor.formColor, borderWidth: 0.5)
        }
    }
    
    @IBOutlet var termsAndConditionLabel: TappableLabel! {
        didSet {
            let attrb = Self.termsAndConditionAttrbString()
            termsAndConditionLabel.isUserInteractionEnabled = true
            termsAndConditionLabel.attributedText = attrb
            guard let range = attrb.string.range(of: LocalisedStrings.SignUp.termsAndCondition) else { return }
            termsAndConditionLabel.tappableRange = NSRange(range, in: attrb.string)
            termsAndConditionLabel.tappableHandler = { [weak self] in
                self?.presentTermsAndCondition()
            }
            termsAndConditionLabel.nonTappablelHandler = { [weak self] in
                self?.tapCheckbox()
            }
        }
    }
    
    @IBOutlet var alrdyHaveAnAccountLabel: TappableLabel! {
        didSet {
            let attrb = Self.alrdyHaveAnAccountAttrbString()
            alrdyHaveAnAccountLabel.isUserInteractionEnabled = true
            alrdyHaveAnAccountLabel.attributedText = attrb
            guard let range = attrb.string.range(of: LocalisedStrings.SignUp.signIn) else { return }
            alrdyHaveAnAccountLabel.tappableRange = NSRange(range, in: attrb.string)
            alrdyHaveAnAccountLabel.tappableHandler = { [weak self] in
                self?.gotoSignin()
            }
        }
    }
    
    @IBOutlet var signUpButton: FormButton! {
        didSet {
            signUpButton.setTitle(LocalisedStrings.SignUp.signUp, for: .normal)
        }
    }
    @IBOutlet var checkboxImageView: UIImageView! {
        didSet {
            checkboxImageView.cornerBorderRadius(cornerRadius: 5, borderColor: UIColor.BorderColor.formColor)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCheckbox))
            checkboxImageView.addGestureRecognizer(tapGesture)
            checkboxImageView.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
    }
    
    override func setupBinding() {
        viewModel.checkboxStateObsevable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] condition in
                self?.checkboxImageView.image = condition ? .init(named: .checkIcon) : nil
            }
            .disposed(by: disposeBag)
        
        viewModel.checkboxStateObsevable
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.signUp()
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoadingObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: signUpButton.rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.alertModelObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] alertModel in
                self?.showAlert(alertModel: alertModel)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func tapCheckbox() {
        viewModel.changeCheckboxState()
    }
    
    private func gotoSignin() {
        // TODO: GO TO SIGN UP
        let vc = LoginViewController.instantiate(from: .login)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentTermsAndCondition() {
        let vc = TermsAndConditionViewController.instantiate(from: .termsAndCondition)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAlert(alertModel: LoginAlertViewController.AlertModel) {
        let alertVC = LoginAlertViewController.instantiate(from: .loginAlert) as! LoginAlertViewController
        presentModally(alertVC, animated: true)
        alertVC.configure(alertModel: alertModel)
    }

}

extension SignUpViewController {
        
    private static func termsAndConditionAttrbString() -> NSMutableAttributedString {
        let title = LocalisedStrings.SignUp.iAgreeWithTermsAndCondition
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1, .foregroundColor: UIColor.TextColor.primaryBlack])
        let range = mutableString.mutableString.range(of: LocalisedStrings.SignUp.termsAndCondition)
        mutableString.addAttributes(
            [
                .foregroundColor: UIColor.TextColor.primaryBlue,
                .font: UIFont.Montserrat.semibold1,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.TextColor.primaryBlue,
            ], range: range)
        
        return mutableString
        
    }
    
    private static func alrdyHaveAnAccountAttrbString() -> NSMutableAttributedString {
        let title = LocalisedStrings.SignUp.alrdyHaveAnAccount
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1, .foregroundColor: UIColor.TextColor.primaryBlack])
        let range = mutableString.mutableString.range(of: LocalisedStrings.SignUp.signIn)
        mutableString.addAttributes(
            [
                .foregroundColor: UIColor.TextColor.primaryBlue,
                .font: UIFont.Montserrat.semibold1,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.TextColor.primaryBlue,
            ], range: range)
        
        return mutableString
        
    }
}

extension SignUpViewController: KeyboardManager {
    
    var scrollView: UIScrollView {
        return signUpScrollView
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowWrapper), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideWrapper), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowWrapper(notification: NSNotification) {
        keyboardWillShow(notification: notification)
    }
    
    @objc private func keyboardWillHideWrapper(notification: NSNotification) {
        keyboardWillHide(notification: notification)
    }
    
}
