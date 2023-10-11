//
//  FooterView.swift
//  Magus
//
//  Created by Jomz on 7/1/23.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    static let identifier = "HeaderTitleView"
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.TextColor.primaryBlue, for: .normal)
        button.titleLabel?.font = .Montserrat.body1
        button.titleLabel?.textAlignment = .right
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initialiseTarget()
    }
    
    private func initialiseTarget() {
        button.addTarget(self, action: #selector(tapSeeAll), for: .touchUpInside)
    }
    
    @objc private func tapSeeAll() {
        actionHandler?()
    }
    
    private func setupView() {
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    var actionHandler: CompletionHandler?
    
    func configure(for actionHandler: CompletionHandler? = nil) {
        self.actionHandler = actionHandler
    }
}
