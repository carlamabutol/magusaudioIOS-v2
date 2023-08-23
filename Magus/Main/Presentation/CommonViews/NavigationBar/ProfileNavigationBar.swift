//
//  ProfileNavigationBar.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit

class ProfileNavigationBar: ReusableXibView {
    
    @IBOutlet private var backButton: UIButton!
    
    @IBOutlet private var saveButton: UIButton!
    
    private var goBackHandler: CompletionHandler?
    private var saveHandler: CompletionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTapActions()
    }
    
    private func setupTapActions() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
    
    func hideShowButton(isHidden: Bool) {
        saveButton.isHidden = isHidden
    }
    
    func configure(goBackHandler: @escaping CompletionHandler,
                   saveHandler: CompletionHandler? = nil) {
        self.goBackHandler = goBackHandler
        self.saveHandler = saveHandler
        self.hideShowButton(isHidden: saveHandler == nil)
    }
    
    @objc private func backAction() {
        goBackHandler?()
    }
    
    @objc private func saveAction() {
        saveHandler?()
    }
    
}
