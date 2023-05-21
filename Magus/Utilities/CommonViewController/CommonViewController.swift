//
//  CommonViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import UIKit
import RxSwift

class CommonViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Background.primary
        setupView()
        setupBinding()
    }
    
    func setupView() { }
    func setupBinding() { }
}
