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
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var placeholderLabel: UILabel! {
        didSet {
            placeholderLabel.font = UIFont.Montserrat.body2
            placeholderLabel.textColor = UIColor.TextColor.placeholderColor
        }
    }
    @IBOutlet var textField: UITextField! {
        didSet {
            textField.font = UIFont.Montserrat.medium2
            textField.textColor = UIColor.TextColor.primaryBlack
        }
    }
    
    var textObservable: BehaviorRelay<String>!
    var placeholder: String = ""
    
    func configure(model: TextFieldView.Model) {
        textField.attributedPlaceholder = Self.placeholderAttributedString(for: model.placeholder)
        textField.keyboardType = model.keyboardType
        textField.isSecureTextEntry = model.isSecureEntry
        textObservable = model.textObservable
        placeholder = model.placeholder
        setupBinding()
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
                self?.removedAndInsertPlaceholderLbl(enteredText)
                print("entered - \(enteredText)")
                return enteredText.isEmpty ? "" : self?.placeholder
            })
            .bind(to: placeholderLabel.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .map { text in return text.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
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
        let textObservable: BehaviorRelay<String>
        var isSecureEntry: Bool = false
        var keyboardType: UIKeyboardType = .default
        
        
    }
}
