//
//  SubliminalGuideViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit

class SubliminalGuideViewController: CommonViewController {
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet {
            navigationBar.backgroundColor = .clear
            navigationBar.configure(
                model: .init(leftButtonHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonModel: nil, rightButtonHandler: nil)
            )
        }
    }
    
    @IBOutlet var guideTitleLabel1: UILabel! {
        didSet {
            guideTitleLabel1.font = .Montserrat.medium17
            guideTitleLabel1.text = LocalisedStrings.LoremIpsum.title
            guideTitleLabel1.numberOfLines = 0
        }
    }
    
    @IBOutlet var guideDescLabel1: UILabel! {
        didSet {
            guideDescLabel1.font = .Montserrat.body4
            guideDescLabel1.text = LocalisedStrings.LoremIpsum.desc1
            guideDescLabel1.numberOfLines = 0
        }
    }
    
    @IBOutlet var guideTitleLabel2: UILabel! {
        didSet {
            guideTitleLabel2.font = .Montserrat.medium17
            guideTitleLabel2.text = LocalisedStrings.LoremIpsum.title
            guideTitleLabel2.numberOfLines = 0
        }
    }

    @IBOutlet var guideDescLabel2: UILabel! {
        didSet {
            guideDescLabel2.font = .Montserrat.body4
            guideDescLabel2.text = LocalisedStrings.LoremIpsum.desc2
            guideDescLabel2.numberOfLines = 0
        }
    }
    
    @IBOutlet var guideTitleLabel3: UILabel! {
        didSet {
            guideTitleLabel3.font = .Montserrat.medium17
            guideTitleLabel3.text = LocalisedStrings.LoremIpsum.title
            guideTitleLabel3.numberOfLines = 0
        }
    }
    
    @IBOutlet var guideDescLabel3: UILabel! {
        didSet {
            guideDescLabel3.font = .Montserrat.body4
            guideDescLabel3.text = LocalisedStrings.LoremIpsum.desc1
            guideDescLabel3.numberOfLines = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
