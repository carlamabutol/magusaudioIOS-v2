//
//  FAQsViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import RxSwift

class FAQsViewController: CommonViewController {
    
    private let viewModel = SettingsViewModel()
    
    @IBOutlet var stackView: UIStackView!
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
//
//    @IBOutlet var whatIsMagusView: CollapsibleTextView! {
//        didSet {
//            whatIsMagusView.configure(
//                with: .init(
//                    title: LocalisedStrings.FAQs.whatIsMagus,
//                    description: LocalisedStrings.LoremIpsum.desc1
//                )
//            )
//        }
//    }
//
//    @IBOutlet var whatIsSubAudioView: CollapsibleTextView! {
//        didSet {
//            whatIsSubAudioView.configure(
//                with: .init(
//                    title: LocalisedStrings.FAQs.whatIsSubliminalAudio,
//                    description: LocalisedStrings.LoremIpsum.desc1
//                )
//            )
//        }
//    }
//
//    @IBOutlet var whatAreBenefitsView: CollapsibleTextView! {
//        didSet {
//            whatAreBenefitsView.configure(
//                with: .init(
//                    title: LocalisedStrings.FAQs.benefits,
//                    description: LocalisedStrings.LoremIpsum.desc1
//                )
//            )
//        }
//    }
//
//    @IBOutlet var isSubliminalAudioSafeView: CollapsibleTextView! {
//        didSet {
//            isSubliminalAudioSafeView.configure(
//                with: .init(
//                    title: LocalisedStrings.FAQs.audiosSafe,
//                    description: LocalisedStrings.LoremIpsum.desc1
//                )
//            )
//        }
//    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.faqsObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] faqs in
                self?.setupFAQs(faqs: faqs)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupFAQs(faqs: [FAQs]) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
        }
        let frame: CGRect = .init(origin: .zero, size: .init(width: self.stackView.width, height: 57))
        for faq in faqs {
            let view = CollapsibleTextView(frame: frame)
            view.configure(with: .init(title: faq.question, description: faq.answer))
            view.backgroundColor = .white
            view.roundCorners(corners: .allCorners, radius: 5)
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
            
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 110).isActive = true
        }
        stackView.insertArrangedSubview(titleLabel, at: 0)
    }
    
}
