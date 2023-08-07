//
//  FormTextFieldView.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import UIKit
import RxSwift
import RxRelay

class FormTextFieldView: ReusableXibView {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            titleLbl.font = .Montserrat.body2
            titleLbl.textColor = .TextColor.placeholderColor
        }
    }
    
    @IBOutlet var textField: UITextField! {
        didSet {
            textField.font = .Montserrat.medium2
            textField.textColor = .TextColor.primaryBlack
        }
    }
    @IBOutlet var eyeButton: UIButton! {
        didSet {
            eyeButton.setImage(UIImage(named: .eyeHide), for: .normal)
            eyeButton.isHidden = true
            eyeButton.tintColor = .black
        }
    }
    @IBOutlet var horizontalStackView: UIStackView!
    
    @IBOutlet var eyeContainerView: UIView!
    
    private var textObservable: BehaviorRelay<String>!
    private var placeholder: String = ""
    private var errorMessage: Observable<String>?
    private var isPassword: Bool = false
    
    func configure(model: TextFieldView.Model) {
        textField.attributedPlaceholder = Self.placeholderAttributedString(for: model.placeholder)
        textField.keyboardType = model.keyboardType
        textField.isSecureTextEntry = model.isSecureEntry
        textObservable = model.textObservable
        placeholder = model.placeholder
        isPassword = model.isSecureEntry
        setupBinding()
        if isPassword {
            eyeButtonBinding()
        } else {
            horizontalStackView.removeArrangedSubview(eyeContainerView)
        }
    }
    
    private func setupBinding() {
        textField.rx.text
            .orEmpty
            .bind(to: textObservable)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .compactMap({ [weak self] enteredText in
                return enteredText.isEmpty ? "" : self?.placeholder
            })
            .bind(to: titleLbl.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .map { text in return text.isEmpty }
            .bind(to: titleLbl.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func eyeButtonBinding() {
        eyeButton.rx.tap
            .map({ [weak self] _ in
                guard let self else { return false }
                return !self.textField.isSecureTextEntry
            })
            .subscribe(onNext: { [weak self] condition in
                guard let self else { return }
                self.textField.isSecureTextEntry = condition
                let imageName: String = condition ? .eyeHide : .eyeShow
                self.eyeButton.setImage(UIImage(named: imageName), for: .normal)
            })
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .map { text in return text.isEmpty }
            .bind(to: eyeButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private static func placeholderAttributedString(for placeholder: String) -> NSMutableAttributedString {
        .init(string: placeholder, attributes: [.font: UIFont.Montserrat.medium2,
                                                .foregroundColor: UIColor.TextColor.placeholderColor])
    }
}

