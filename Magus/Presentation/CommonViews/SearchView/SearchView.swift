//
//  SearchView.swift
//  Magus
//
//  Created by Jomz on 7/25/23.
//

import UIKit

class SearchView: ReusableXibView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var closeContainerView: UIView!
    @IBOutlet var clearImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        clearImageView.translatesAutoresizingMaskIntoConstraints = false
        clearImageView.centerXAnchor.constraint(equalTo: closeContainerView.centerXAnchor).isActive = true
        clearImageView.centerYAnchor.constraint(equalTo: closeContainerView.centerYAnchor).isActive = true
        clearImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        clearImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clear))
        closeContainerView.addGestureRecognizer(tapGesture)
    }
    
    var onClear: ((() -> Void)?)
    
    func configure(onClear: (() -> Void)?) {
        self.onClear = onClear
    }
    
    @objc private func clear() {
        textField.text?.removeAll()
        onClear?()
    }
    
}
