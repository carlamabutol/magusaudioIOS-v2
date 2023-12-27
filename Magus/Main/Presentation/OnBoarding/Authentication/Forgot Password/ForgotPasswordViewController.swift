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
    private var loadingVC: UIViewController?
    
    @IBOutlet var forgotPasswordScrollView: UIScrollView!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalisedStrings.ForgotPassword.title
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = LocalisedStrings.ForgotPassword.description
            descriptionLabel.font = UIFont.Montserrat.body1
        }
    }
    
    @IBOutlet var textFieldView: TextFieldView! {
        didSet {
            textFieldView.configure(model: .init(placeholder: LocalisedStrings.Auth.email, textRelay: viewModel.emailRelay))
        }
    }
    
    @IBOutlet var submitButton: FormButton! {
        didSet {
            submitButton.setTitle(LocalisedStrings.ForgotPassword.submit, for: .normal)
        }
    }
    
    @IBOutlet var signUpLabel: TappableLabel! {
        didSet {
            signUpLabel.isUserInteractionEnabled = true
            signUpLabel.attributedText = Self.dontHaveAnAccountAttributedString()
            guard let range = signUpLabel.attributedText?.string.range(of: LocalisedStrings.Login.signUp) else { return }
            signUpLabel.tappableRange = NSRange(range, in: signUpLabel.attributedText!.string)
            signUpLabel.tappableHandler = { [weak self] in
                self?.gotoSignup()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.submitButtonIsEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.backRelay.asObservable()
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.alertRelay.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] alertEnum in
                switch alertEnum {
                case .loading(let isLoading):
                    if isLoading {
                        self?.loadingVC = self?.presentLoading()
                    }
                case .alertModal(let model):
                    if self?.loadingVC == nil {
                        self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                    } else {
                        self?.loadingVC?.dismiss(animated: true, completion: {
                            self?.loadingVC = nil
                            self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.forgotPassword()
            }
            .disposed(by: disposeBag)
        
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
        let title = LocalisedStrings.Login.dontHaveAnAccount + LocalisedStrings.Login.signUp
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1, .foregroundColor: UIColor.TextColor.primaryBlack])
        let range = mutableString.mutableString.range(of: LocalisedStrings.Login.signUp)
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
