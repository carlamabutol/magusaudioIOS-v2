//
//  PlayerOptionViewController.swift
//  Magus
//
//  Created by Jomz on 10/30/23.
//

import UIKit
import RxSwift

class PlayerOptionViewController: CommonViewController {
    
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // Make the
    }
    
    override func setupBinding() {
        super.setupBinding()
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.closeButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        dismissCompletion?()
    }
    
    private var dismissCompletion: CompletionHandler?
    
    func configure(subliminal: Subliminal, dismiss: @escaping CompletionHandler) {
        dismissCompletion = dismiss
    }
    
}
