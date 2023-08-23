//
//  TextFieldView.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/19/23.
//

import UIKit
import RxCocoa
import RxSwift

class TextFieldView: ReusableXibView {
    
    @IBOutlet private (set)var stackView: UIStackView!
    
    @IBOutlet var placeholderStackView: UIStackView!
    @IBOutlet private (set)var placeholderLabel: UILabel! {
        didSet {
            placeholderLabel.font = UIFont.Montserrat.body2
            placeholderLabel.textColor = UIColor.TextColor.placeholderColor
        }
    }
    
    @IBOutlet var wrongInputLabel: UILabel!
    
    @IBOutlet private (set)var textField: UITextField! {
        didSet {
            textField.font = UIFont.Montserrat.medium2
            textField.textColor = UIColor.TextColor.primaryBlack
        }
    }
    
    @IBOutlet private (set)var eyeButton: UIButton! {
        didSet {
            eyeButton.setImage(UIImage(named: .eyeHide), for: .normal)
            eyeButton.isHidden = true
            eyeButton.tintColor = .black
        }
    }
    
    private var textObservable: BehaviorRelay<String>!
    private var placeholder: String = ""
    private var errorMessage: Observable<String>?
    private var isPassword: Bool = false
    
    func configure(model: TextFieldView.Model) {
        textField.attributedPlaceholder = Self.placeholderAttributedString(for: model.placeholder)
        textField.keyboardType = model.keyboardType
        textField.isSecureTextEntry = model.isSecureEntry
        textObservable = model.textRelay
        placeholder = model.placeholder
        isPassword = model.isSecureEntry
        setupBinding()
        if isPassword {
            eyeButtonBinding()
        }
    }
    
    fileprivate func removedAndInsertPlaceholderLbl(_ enteredText: String) {
        if enteredText.isEmpty {
            if stackView.arrangedSubviews.first != placeholderLabel {
                stackView.insertArrangedSubview(placeholderLabel, at: 0)
            }
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
            .bind(to: placeholderLabel.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .map { text in return text.isEmpty }
            .bind(to: placeholderStackView.rx.isHidden)
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

extension TextFieldView {
    
    struct Model {
        let placeholder: String
        let textRelay: BehaviorRelay<String>
        var isSecureEntry: Bool = false
        var keyboardType: UIKeyboardType = .default
        var errorMessage: Observable<String>?
        
    }
}
