//
//  SettingsViewController.swift
//  Magus
//
//  Created by Jomz on 8/10/23.
//

import UIKit
import RxSwift

class SettingsViewController: CommonViewController {
    var profileViewModel: ProfileViewModel!
    
    private let viewModel = SettingsViewModel()
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold17
        }
    }
    @IBOutlet var howMagusWorksButton: UIButton! {
        didSet {
            howMagusWorksButton.titleLabel?.font = .Montserrat.bold15
        }
    }
        
    @IBOutlet var subliminalGuideButton: UIButton! {
        didSet {
            subliminalGuideButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    
    @IBOutlet var faqsButton: UIButton! {
        didSet {
            faqsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var termsButton: UIButton! {
        didSet {
            termsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var contactUsButton: UIButton! {
        didSet {
            contactUsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var rateUsButton: UIButton! {
        didSet {
            rateUsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var logoutButton: UIButton! {
        didSet {
            logoutButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        logoutButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.viewModel.logout()
            }
            .disposed(by: disposeBag)
        
        howMagusWorksButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.goToHowItWorks()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func goToHowItWorks() {
        let viewController = HowMagusWorksViewController.instantiate(from: .howMagusWorks)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
