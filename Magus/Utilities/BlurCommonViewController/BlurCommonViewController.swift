//
//  BlurCommonViewController.swift
//  Magus
//
//  Created by Jomz on 10/30/23.
//

import UIKit

class BlurCommonViewController: CommonViewController {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isHidden = true

        view.addSubview(blurView)
    }
    
    func toggleBlurEffect(isHidden: Bool) {
        UIView.transition(with: blurView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.blurView.isHidden = isHidden
        })
    }
    
}
