//
//  ChangePasswordViewController.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import UIKit
import RxSwift

class ChangePasswordViewController: CommonViewController {
    
    private let viewModel = ChangePasswordViewModel()
    private var loadingVC: UIViewController?
    
    @IBOutlet var navigationBar: ProfileNavigationBar!
    
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            let accountPrivacyAttrb = NSAttributedString(string: "\(LocalisedStrings.EditProfile.accountPrivacy.uppercased()) >", attributes: [.font: UIFont.Montserrat.bold12])
            let changePassAttrb = NSAttributedString(string: " " + LocalisedStrings.EditProfile.changePassword.uppercased(), attributes: [.font: UIFont.Montserrat.bold17])
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
            requirementsTitleLbl.text = LocalisedStrings.ChangePassword.passwordMust
            requirementsTitleLbl.textColor = .TextColor.primaryBlack.withAlphaComponent(0.56)
        }
    }
    
    @IBOutlet var contains8CharacterReqView: PasswordRequirementView!
    
    @IBOutlet var containsLowercaseReqView: PasswordRequirementView!
    
    @IBOutlet var containsUppercaseReqView: PasswordRequirementView!

    @IBOutlet var containsNumberReqView: PasswordRequirementView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.configure(
            model: .init(
                leftButtonHandler: {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                },
                rightButtonModel: .init(title: "Save", image: nil),
                rightButtonHandler: { [weak self] in
                    self?.presentDefaultAlert()
                }
            )
        )
        configureForms()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.saveButtonIsEnabled
            .bind(to: navigationBar.saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.backRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.alertRelay.asObservable()
            .observe(on: MainScheduler.instance)
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
                        self?.loadingVC?.dismiss(animated: false, completion: {
                            self?.loadingVC = nil
                            self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.contains8CharacterObservable
            .subscribe { [weak self] model in
                self?.contains8CharacterReqView.configure(model: model)
            }
            .disposed(by: disposeBag)
        
        viewModel.includeLowerCharacterObservable
            .subscribe { [weak self] model in
                self?.containsLowercaseReqView.configure(model: model)
            }
            .disposed(by: disposeBag)
        
        viewModel.includeUppercaseCharacterObservable
            .subscribe { [weak self] model in
                self?.containsUppercaseReqView.configure(model: model)
            }
            .disposed(by: disposeBag)
        
        viewModel.includeNumberCharacterObservable
            .subscribe { [weak self] model in
                self?.containsNumberReqView.configure(model: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureForms() {
        currentPasswordForm.configure(
            model: .init(placeholder: LocalisedStrings.EditProfile.currentPassword,
                         textRelay: viewModel.currentPasswordRelay,
                         isSecureEntry: true)
        )
        newPasswordForm.configure(
            model: .init(placeholder: LocalisedStrings.EditProfile.enterNewPassword,
                         textRelay: viewModel.enterNewPasswordRelay,
                         isSecureEntry: true)
        )
        confirmNewPasswordForm.configure(
            model: .init(placeholder: LocalisedStrings.EditProfile.confirmPassword,
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
            self?.viewModel.changePassword()
            self?.dismiss(animated: true)
        }))
    }
}
