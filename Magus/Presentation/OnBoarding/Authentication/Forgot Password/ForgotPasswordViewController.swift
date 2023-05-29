//
//  ForgotPasswordViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/27/23.
//

import UIKit
import RxSwift

class ForgotPasswordViewController: CommonViewController {
    
    private let viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
    
    @IBOutlet var forgotPasswordScrollView: UIScrollView!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalizedStrings.ForgotPassword.title
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = LocalizedStrings.ForgotPassword.description
            descriptionLabel.font = UIFont.Montserrat.body1
        }
    }
    
    @IBOutlet var textFieldView: TextFieldView! {
        didSet {
            textFieldView.configure(model: .init(placeholder: LocalizedStrings.Auth.email, textObservable: viewModel.emailRelay))
        }
    }
    
    @IBOutlet var submitButton: FormButton! {
        didSet {
            submitButton.setTitle(LocalizedStrings.ForgotPassword.submit, for: .normal)
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

    }
    
    private func gotoSignup() {
        // TODO: GO TO SIGN UP
        let vc = SignUpViewController.instantiate(from: .signUp)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ForgotPasswordViewController: KeyboardManager {
    
    var scrollView: UIScrollView {
        return self.forgotPasswordScrollView
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


extension ForgotPasswordViewController {
    
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
