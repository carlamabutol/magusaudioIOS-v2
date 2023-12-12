//
//  HeaderTitleView.swift
//  Magus
//
//  Created by Jomz on 6/26/23.
//

import UIKit

class HeaderTitleView: UICollectionReusableView {
    
    static let identifier = "HeaderTitleView"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Montserrat.bold17
        label.textColor = .black
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(title: String) {
        label.text = title
    }
    
}


class HeaderTitleRightButtonView: UICollectionReusableView {
    
    static let identifier = "HeaderTitleRightButtonView"
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .Montserrat.bold17
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: .collapsedUp)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGestures()
        setupView()
    }
    
    private func setupTapGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionHandler))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func actionHandler() {
        tapAction?()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(containerView)

        containerView.addSubview(imageIcon)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 20),
            imageIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            imageIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            imageIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            imageIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: isCollapsed ? [.topRight, .topLeft] : .allCorners, radius: 10)
    }
    
    var tapAction: CompletionHandler?
    var isCollapsed: Bool = false
    
    func configure(text: String, isCollapsed: Bool = false, tapAction: CompletionHandler? = nil) {
        self.label.text = text
        self.tapAction = tapAction
        self.isCollapsed = isCollapsed
    }
    
}
