//
//  EditProfileViewController.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit
import RxSwift

class EditProfileViewController: CommonViewController {
    
    let viewModel = EditProfileViewModel()
    
    @IBOutlet private var containerProfileImageView: UIView! {
        didSet {
            containerProfileImageView.circle()
            containerProfileImageView.applyShadow(radius: 5, shadowOpacity: 0.2, offset: .init(width: 0, height: 5))
        }
    }
    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            profileImageView.sd_setImage(with: viewModel.profileImage(), placeholderImage: .init(named: "Cover Image"))
            profileImageView.circle()
            profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet var userDetailsTitleLbl: UILabel! {
        didSet {
            userDetailsTitleLbl.font = .Montserrat.bold17
            userDetailsTitleLbl.text = LocalizedStrings.EditProfile.userDetailsTitle
        }
    }
    
    @IBOutlet var firstNameForm: FormTextFieldView! {
        didSet {
            firstNameForm.backgroundColor = .white
        }
    }
    @IBOutlet var lastNameForm: FormTextFieldView! {
        didSet {
            lastNameForm.backgroundColor = .white
        }
    }
    
    @IBOutlet var emailForm: FormTextFieldView! {
        didSet {
            emailForm.backgroundColor = .white
        }
    }
    
    @IBOutlet var accountPrivacyLbl: UILabel! {
        didSet {
            accountPrivacyLbl.font = .Montserrat.bold17
            accountPrivacyLbl.text = LocalizedStrings.EditProfile.accountPrivacy
        }
    }
    @IBOutlet var changePasswordButton: UIButton! {
        didSet {
            changePasswordButton.setTitle(LocalizedStrings.EditProfile.changePassword, for: .normal)
            changePasswordButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var deleteAccountButton: UIButton! {
        didSet {
            deleteAccountButton.setTitle(LocalizedStrings.EditProfile.deletePassword, for: .normal)
            deleteAccountButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet private var profileNavigationBar: ProfileNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        profileNavigationBar.configure { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        } saveHandler: { [weak self] in
            self?.viewModel.updateUserDetails()
        }
        
        firstNameForm.configure(
            model: .init(
                placeholder: LocalizedStrings.EditProfile.firstName,
                textRelay: viewModel.firstNameRelay
            )
        )
        lastNameForm.configure(
            model: .init(
                placeholder: LocalizedStrings.EditProfile.lastName,
                textRelay: viewModel.lastNameRelay
            )
        )
        emailForm.configure(
            model: .init(
                placeholder: LocalizedStrings.EditProfile.email,
                textRelay: viewModel.emailRelay
            )
        )
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        changePasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _  in
                self?.pushToChangePasswordViewController()
            })
            .disposed(by: disposeBag)
        
        deleteAccountButton.rx.tap
            .subscribe(onNext: {[weak self] _  in
                self?.pushToDeleteAccountViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.showSaveButton
            .subscribe { [weak self] condition in
                self?.profileNavigationBar.hideShowButton(isHidden: !condition)
            }
            .disposed(by: disposeBag)
        
        viewModel.alertModelObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] model in
                self?.showAlert(alertModel: model)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func pushToChangePasswordViewController() {
        let changePasswordVC = ChangePasswordViewController.instantiate(from: .changePassword)
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    private func pushToDeleteAccountViewController() {
        let deleteAccountVC = DeleteAccountViewController.instantiate(from: .deleteAccount)
        navigationController?.pushViewController(deleteAccountVC, animated: true)
    }
    
    private func showSampleAlert() {
        let alertVC = presentAlert(title: "Sample", message: "Alert")
        present(alertVC, animated: true)
    }
    
    private func showAlert(alertModel: ProfileAlertViewController.AlertModel) {
        let alertVC = ProfileAlertViewController.instantiate(from: .profileAlert) as! ProfileAlertViewController
        presentModally(alertVC, animated: true)
        alertVC.configure(alertModel: alertModel)
    }
    
}
