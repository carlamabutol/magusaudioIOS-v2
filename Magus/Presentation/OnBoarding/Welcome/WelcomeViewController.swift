//
//  WelcomeViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import UIKit
import RxCocoa
import RxSwift

class WelcomeViewController: CommonViewController {
    
    private let viewModel = WelcomeViewModel()
    
    @IBOutlet private(set) var createAccountLabel: TappableLabel! {
        didSet {
            let attrb = Self.createAccountAttributedString()
            createAccountLabel.isUserInteractionEnabled = true
            createAccountLabel.attributedText = attrb
            guard let range = attrb.string.range(of: LocalizedStrings.Welcome.createAccountForFree) else { return }
            createAccountLabel.tappableRange = NSRange(range, in: attrb.string)
            createAccountLabel.tappableHandler = { [weak self] in
                self?.gotoSignup()
            }
        }
    }
    @IBOutlet var signInButton: FormButton! {
        didSet {
            signInButton.setTitle(LocalizedStrings.Welcome.signInWithEmail, for: .normal)
            signInButton.titleLabel?.textAlignment = .center
            signInButton.titleLabel?.numberOfLines = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.Background.primary
    }
    
    override func setupBinding() {
        super.setupBinding()
        signInButton.rx.tap
            .subscribe { [weak self] _ in
                self?.signInButtonAction()
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func signInButtonAction() {
        viewModel.signInAction()
    }
    
    private func gotoSignup() {
        // TODO: GO TO SIGN UP
        let vc = SignUpViewController.instantiate(from: .signUp)
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

extension WelcomeViewController {
    
    private static func createAccountAttributedString() -> NSMutableAttributedString {
        let title = LocalizedStrings.Welcome.newHere + LocalizedStrings.Welcome.createAccountForFree
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1, .foregroundColor: UIColor.TextColor.primaryBlack])
        let range = mutableString.mutableString.range(of: LocalizedStrings.Welcome.createAccountForFree)
        mutableString.addAttributes(
            [
                .foregroundColor: UIColor.TextColor.primaryBlue,
                .font: UIFont.Montserrat.semibold1,
                .underlineColor: UIColor.TextColor.primaryBlue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: range)
        
        
        return mutableString
    }
    
}
