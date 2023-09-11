//
//  FormButton.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/19/23.
//

import UIKit

class FormButton: UIButton {
    // 2
    var spinner = UIActivityIndicatorView()
    // 3
    var isLoading = false {
        didSet {
            // whenever `isLoading` state is changed, update the view
            updateView()
            print("ABC loading")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.white
        setTitleColor(.TextColor.primaryBlue, for: .normal)
        setTitleColor(.TextColor.primaryBlue, for: .highlighted)
        titleLabel?.font = UIFont.Montserrat.bold1
        cornerRadius(with: 5)
        applyShadow(radius: 5, offset: .init(width: 0, height: 4))
        layer.shouldRasterize = false
        
    }
    
    private func setupView() {
        // 5
        spinner.hidesWhenStopped = true
        // to change spinner color
        spinner.color = .TextColor.primaryBlue
        // default style
        spinner.style = .medium
        
        // 6
        // add as button subview
        addSubview(spinner)
        // set constraints to always in the middle of button
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // 7
    private func updateView() {
        if isLoading {
            spinner.startAnimating()
            setTitleColor(.clear, for: .normal)
            setTitleColor(.clear, for: .highlighted)
            // to prevent multiple click while in process
            self.isEnabled = false
        } else {
            spinner.stopAnimating()
            setTitleColor(.TextColor.primaryBlue, for: .normal)
            setTitleColor(.TextColor.primaryBlue, for: .highlighted)
            self.isEnabled = true
        }
    }
}
