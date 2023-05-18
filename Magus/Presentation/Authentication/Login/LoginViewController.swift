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
    
    @IBOutlet var scrollContentView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet private(set) var magusLogoImageView: UIImageView! {
        didSet {
            magusLogoImageView.image = UIImage(named: .magusLogoSignIn)
            magusLogoImageView.contentMode = .scaleAspectFit
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBinding() {
//        loginButton.rx.tap
//            .bind { [weak self] in
//                self?.loginTapAction()
//                print("button tapped")
//            }
//            .disposed(by: disposeBag)
    }
    
    private func loginTapAction() {
        viewModel.loginAction()
    }

}
