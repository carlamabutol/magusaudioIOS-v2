//
//  DefaultAlertViewController.swift
//  Magus
//
//  Created by Jomz on 8/8/23.
//

import UIKit
import RxSwift

class DefaultAlertViewController: CommonViewController {
    
    @IBOutlet var messageLbl: UILabel! {
        didSet {
            messageLbl.numberOfLines = 0
        }
    }
     
    @IBOutlet var confirmButton: FormButton! {
        didSet {
            confirmButton.setTitle("Confirm", for: .normal)
        }
    }
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .white
            containerView.cornerRadius(with: 10)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func setupBinding() {
        super.setupBinding()
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismissModal()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissModal() {
        actionHandler?()
    }
    
    var actionHandler: (() -> Void)?
    
    
    func configure(_ alertViewModel: AlertViewModel) {
        messageLbl.text = alertViewModel.message
        actionHandler = alertViewModel.actionHandler
    }
    
}
