//
//  HowMagusWorkInfoViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 10/11/23.
//

import UIKit

class HowMagusWorkInfoViewController: CommonViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.medium20
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .Montserrat.body3
        }
    }
    
    func configure(with model: HowMagusWorksViewModel.Model) {
        imageView.image = UIImage(named: model.image)
        imageView.contentMode = .scaleAspectFit
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
    
}
