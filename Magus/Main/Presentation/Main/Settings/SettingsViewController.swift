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
        
        subliminalGuideButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.goToSubliminalGuide()
            }
            .disposed(by: disposeBag)
        
        faqsButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.goToFAQs()
            }
            .disposed(by: disposeBag)
        
        termsButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.goToCompanyDocument(docutype: .terms)
            }
            .disposed(by: disposeBag)
        
        contactUsButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.goToContactUs()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func goToHowItWorks() {
        let viewController = HowMagusWorksViewController.instantiate(from: .howMagusWorks)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToSubliminalGuide() {
        let viewController = SubliminalGuideViewController.instantiate(from: .subliminalGuide)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToFAQs() {
        let viewController = FAQsViewController.instantiate(from: .faqs)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToCompanyDocument(docutype: CompanyDocumentViewModel.DocuType) {
        let viewController = CompanyDocumentViewController.instantiate(from: .companyDocument) as! CompanyDocumentViewController
        viewController.loadViewIfNeeded()
        viewController.configure(docutype: docutype)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func goToContactUs() {
        let viewController = ContactUsViewController.instantiate(from: .contactUs)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
