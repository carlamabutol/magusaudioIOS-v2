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
    
    @IBOutlet private(set) var createAccountLabel: UILabel! {
        didSet {
            createAccountLabel.attributedText = Self.createAccountAttributedString()
        }
    }
    
    @IBOutlet private(set) var signInButton: UIButton! {
        didSet {
            signInButton.backgroundColor = UIColor.white
            signInButton.setTitle(LocalizedStrings.Welcome.signInWithEmail, for: .normal)
            signInButton.setTitleColor(.TextColor.welcomeBlue, for: .normal)
            signInButton.titleLabel?.font = UIFont.Montserrat.bold1
            signInButton.dropShadow(radius: 5, offsetY: 3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
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
    
}

extension WelcomeViewController {
    
    private static func createAccountAttributedString() -> NSMutableAttributedString {
        let title = LocalizedStrings.Welcome.newHere + LocalizedStrings.Welcome.createAccountForFree
        let mutableString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.Montserrat.body1!])
        let range = mutableString.mutableString.range(of: LocalizedStrings.Welcome.createAccountForFree)
        mutableString.addAttributes(
            [
                .foregroundColor: UIColor.TextColor.welcomeBlue,
                .font: UIFont.Montserrat.semibold1!,
                .underlineColor: UIColor.TextColor.welcomeBlue,
                .underlineStyle: NSUnderlineStyle.thick
            ], range: range)
        
        
        return mutableString
    }
    
}
