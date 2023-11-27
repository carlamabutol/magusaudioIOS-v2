//
//  FAQsViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit

class FAQsViewController: CommonViewController {
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
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title1
            titleLabel.text = LocalisedStrings.FAQs.title
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet var whatIsMagusView: CollapsibleTextView! {
        didSet {
            whatIsMagusView.configure(
                with: .init(
                    title: LocalisedStrings.FAQs.whatIsMagus,
                    description: LocalisedStrings.LoremIpsum.desc1
                )
            )
        }
    }
    
    @IBOutlet var whatIsSubAudioView: CollapsibleTextView! {
        didSet {
            whatIsSubAudioView.configure(
                with: .init(
                    title: LocalisedStrings.FAQs.whatIsSubliminalAudio,
                    description: LocalisedStrings.LoremIpsum.desc1
                )
            )
        }
    }
    
    @IBOutlet var whatAreBenefitsView: CollapsibleTextView! {
        didSet {
            whatAreBenefitsView.configure(
                with: .init(
                    title: LocalisedStrings.FAQs.benefits,
                    description: LocalisedStrings.LoremIpsum.desc1
                )
            )
        }
    }
    
    @IBOutlet var isSubliminalAudioSafeView: CollapsibleTextView! {
        didSet {
            isSubliminalAudioSafeView.configure(
                with: .init(
                    title: LocalisedStrings.FAQs.audiosSafe,
                    description: LocalisedStrings.LoremIpsum.desc1
                )
            )
        }
    }
    
}
