//
//  EditProfileViewController.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit
import RxSwift
import YPImagePicker

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
            profileImageView.sd_setImage(with: viewModel.profileImage(), placeholderImage: .init(named: .coverImage))
            profileImageView.circle()
            profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet var userDetailsTitleLbl: UILabel! {
        didSet {
            userDetailsTitleLbl.font = .Montserrat.bold17
            userDetailsTitleLbl.text = LocalisedStrings.EditProfile.userDetailsTitle
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
            emailForm.isUserInteractionEnabled = false
            emailForm.backgroundColor = .white
        }
    }
    
    @IBOutlet var accountPrivacyLbl: UILabel! {
        didSet {
            accountPrivacyLbl.font = .Montserrat.bold17
            accountPrivacyLbl.text = LocalisedStrings.EditProfile.accountPrivacy
        }
    }
    @IBOutlet var changePasswordButton: UIButton! {
        didSet {
            changePasswordButton.setTitle(LocalisedStrings.EditProfile.changePassword, for: .normal)
            changePasswordButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var deleteAccountButton: UIButton! {
        didSet {
            deleteAccountButton.setTitle(LocalisedStrings.EditProfile.deletePassword, for: .normal)
            deleteAccountButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet private var profileNavigationBar: ProfileNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageTapInitialiser()
        hideKeyboardOnTap()
        profileNavigationBar.configure(
            model: .init(
                leftButtonHandler: {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonModel: .init(title: "Save", image: nil), rightButtonHandler: { [weak self] in
                    self?.viewModel.updateUserDetails()
                }
            )
        )
        
        firstNameForm.configure(
            model: .init(
                placeholder: LocalisedStrings.EditProfile.firstName,
                textRelay: viewModel.firstNameRelay
            )
        )
        lastNameForm.configure(
            model: .init(
                placeholder: LocalisedStrings.EditProfile.lastName,
                textRelay: viewModel.lastNameRelay
            )
        )
        emailForm.configure(
            model: .init(
                placeholder: LocalisedStrings.EditProfile.email,
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
                self?.updateProfile()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func updateProfile() {
        profileImageView.sd_setImage(with: viewModel.profileImage(), placeholderImage: .init(named: .coverImage))
    }
    
    private func addImageTapInitialiser() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto))
        containerProfileImageView.addGestureRecognizer(tapGesture)
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
        presentAlert(title: "Sample", message: "Alert")
    }
    
    private func showAlert(alertModel: ProfileAlertViewController.AlertModel) {
        let alertVC = ProfileAlertViewController.instantiate(from: .profileAlert) as! ProfileAlertViewController
        presentModally(alertVC, animated: true)
        alertVC.configure(alertModel: alertModel)
    }
    
    @objc private func changeProfilePhoto() {
        let picker = YPImagePicker()
        picker.didFinishPicking { [weak self] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                if let dataImage = photo.image.jpegData(compressionQuality: 0.9) {
                    self?.viewModel.changeProfilePhoto(dataImage)
                } else {
                    
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
}
