//
//  LoginViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import UIKit
import RxSwift

class LoginViewController: CommonViewController {

    private let viewModel: LoginViewModel = LoginViewModel()
    
    @IBOutlet var loginScrollView: UIScrollView!
    @IBOutlet var scrollContentView: UIView!
    
    @IBOutlet private(set) var magusLogoImageView: UIImageView! {
        didSet {
            magusLogoImageView.image = UIImage(named: .magusLogoSignIn)
            magusLogoImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var welcomeTitleLbl: UILabel! {
        didSet {
            welcomeTitleLbl.font = UIFont.Montserrat.title
            welcomeTitleLbl.text = LocalizedStrings.Login.welcomeBackTitle
        }
    }
    
    @IBOutlet var descLbl: UILabel! {
        didSet {
            descLbl.font = UIFont.Montserrat.body1
            descLbl.text = LocalizedStrings.Login.signInStartListening
        }
    }
    
    @IBOutlet var formContainerView: UIView! {
        didSet {
            formContainerView.cornerBorderRadius(cornerRadius: 5, borderColor: UIColor.BorderColor.formColor, borderWidth: 0.5)
        }
    }
    
    @IBOutlet var emailTextFieldView: TextFieldView! {
        didSet {
            emailTextFieldView.configure(model: .init(placeholder: "Email", textObservable: viewModel.userName, keyboardType: .emailAddress))
        }
    }
    
    @IBOutlet var passwordTextFieldView: TextFieldView! {
        didSet {
            passwordTextFieldView.configure(model: .init(placeholder: "Password", textObservable: viewModel.password, isSecureEntry: true))
        }
    }
    
    @IBOutlet var dividerView: UIView! {
        didSet {
            dividerView.backgroundColor = UIColor.BorderColor.formColor
        }
    }
    
    @IBOutlet var forgotPasswordButton: UIButton! {
        didSet {
            let attributedString = NSAttributedString(string: LocalizedStrings.Login.forgotPassword, attributes: [
                .font: UIFont.Montserrat.bold2,
                .foregroundColor: UIColor.TextColor.primaryBlue,
                .underlineColor: UIColor.TextColor.primaryBlue,
                .underlineStyle: NSUnderlineStyle.single.rawValue]
            )
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .highlighted)
        }
    }
    
    @IBOutlet var signInButton: FormButton! {
        didSet {
            signInButton.setTitle(LocalizedStrings.Login.signIn, for: .normal)
        }
    }
    
    @IBOutlet var signUpLabel: TappableLabel! {
        didSet {
            signUpLabel.isUserInteractionEnabled = true
            signUpLabel.attributedText = Self.dontHaveAnAccountAttributedString()
            guard let range = signUpLabel.attributedText?.string.range(of: LocalizedStrings.Login.signUp) else { return }
            signUpLabel.tappableRange = NSRange(range, in: signUpLabel.attributedText!.string)
            signUpLabel.tappableHandler = { [weak self] in
                self?.gotoSignup()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        hideKeyboardOnTap()
    }
    
    override func setupBinding() {
        signInButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in self?.viewModel.loginAction() })
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in self?.gotoForgotPassword() })
            .disposed(by: disposeBag)
    }
    
    private func gotoSignup() {
        // TODO: GO TO SIGN UP
        let alert = presentAlert(title: "Tapped Sign Up")
        present(alert, animated: true)
    }
    
    private func gotoForgotPassword() {
        // TODO: GO TO FORGOT PASSWORD
        let alert = presentAlert(title: "Tapped Forgot Password")
        present(alert, animated: true)
    }

}

extension LoginViewController {
    
    private static func dontHaveAnAccountAttributedString() -> NSMutableAttributedString {
        let title = LocalizedStrings.Login.dontHaveAnAccount + LocalizedStrings.Login.signUp
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1, .foregroundColor: UIColor.TextColor.primaryBlack])
        let range = mutableString.mutableString.range(of: LocalizedStrings.Login.signUp)
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

extension LoginViewController: KeyboardManager {
    
    var scrollView: UIScrollView {
        return loginScrollView
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
