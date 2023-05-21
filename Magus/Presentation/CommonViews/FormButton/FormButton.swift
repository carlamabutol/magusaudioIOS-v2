//
//  FormButton.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/19/23.
//

import UIKit

class FormButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.white
        setTitleColor(.TextColor.primaryBlue, for: .normal)
        setTitleColor(.TextColor.primaryBlue, for: .highlighted)
        titleLabel?.font = UIFont.Montserrat.bold1
        applyShadow(radius: 5, offset: .init(width: 0, height: 4))
    }
}
